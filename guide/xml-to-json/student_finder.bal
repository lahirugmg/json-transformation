// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/io;
import ballerina/http;
import ballerina/log;

endpoint http:Listener listener {
    port: 9090
};

endpoint http:Client studentInfoEP {
    url: "http://localhost:9091/studentinfo"
};

endpoint http:Client schoolInfoEP {
    url: "http://localhost:9092/schoolinfo"
};

// Student finder service.
@http:ServiceConfig { basePath: "/studentfinder" }
service<http:Service> studentFinder bind listener {


    // Resource that handles the HTTP GET requests that are directed to a specific
    // student using path '/<studentId>'
    @http:ResourceConfig {
        methods: ["GET"],
        path: "/{studentId}"
    }
    getStudentById(endpoint client, http:Request req, string studentId) {

        http:Response finderResponse;

        try {
            string studentInfoPath = "/" + studentId;
            var studentInfoResp = check studentInfoEP->get(untaint studentInfoPath);
            xml studentInfoXml = check studentInfoResp.getXmlPayload();

            string schoolId = studentInfoXml.selectDescendants("schoolId").getTextValue();
            string schoolInfoPath = "/" + schoolId;
            var schoolInfoResp = check schoolInfoEP->get(untaint schoolInfoPath);
            json schoolInfoJson = check schoolInfoResp.getJsonPayload();

            log:printInfo("School info response " + schoolInfoJson.toString());
            _ = client->respond(finderResponse);

        } catch (error err) {
            log:printError(err.message);
        }
    }

    // Resource that handles the HTTP GET requests that are used to search student with query parametr school Id or addmission year
    // using path '/'
    @http:ResourceConfig {
        path: "/*"
    }
    getStudentBySearch(endpoint client, http:Request req) {

        http:Response finderResponse;

        var params = req.getQueryParams();
        string studentInfoPath;
        if (params.hasKey("schoolId")) {

            studentInfoPath = "?schoolId=" + <string>params.schoolId;

        } else if (params.hasKey("addmissionYear")) {

            studentInfoPath = "?addmissionYear=" + <string>params.addmissionYear;
        }
        try {
            http:Response studentInfoResp = check studentInfoEP->get(untaint studentInfoPath);

            xml studentInfoXml = check studentInfoResp.getXmlPayload();

            log:printInfo("Student info response " + io:sprintf("%l", studentInfoXml));
            finderResponse.setJsonPayload(studentInfoXml.toJSON({}));

        } catch (error err){
            log:printError(err.message);
        }
        _ = client->respond(finderResponse);

    }
}