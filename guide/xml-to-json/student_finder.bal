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

        string studentInfoPath = "/" + studentId;
        var studentInfoResp = studentInfoEP->get(untaint studentInfoPath);

        match studentInfoResp {
            http:Response response => {
                match (response.getXmlPayload()) {

                    xml res => {
                        log:printInfo("Student info response " + io:sprintf("%l", res));

                        string schoolId = res.selectDescendants("schoolId").getTextValue();

                        string schoolInfoPath = "/" + schoolId;
                        log:printInfo("School info path " + schoolInfoPath);

                        var schoolInfoResp = schoolInfoEP->get(untaint schoolInfoPath);

                        match schoolInfoResp {
                            http:Response response => {
                                match (response.getJsonPayload()) {

                                    json sclRes => {
                                        log:printInfo("School info response " + sclRes.toString());
                                    }

                                    error err => log:printError(err.message);
                                }
                            }

                            error err => log:printError(err.message);
                        }

                        finderResponse.setJsonPayload(res.toJSON({}));
                    }

                    error err => log:printError(err.message);
                }
            }

            error err => log:printError(err.message);
        }
        _ = client->respond(finderResponse);
    }

    // Resource that handles the HTTP GET requests that are used to search student with query parametr school Id or addmission year
    // using path '/'
    @http:ResourceConfig {
        path: "/*"
    }
    getStudentBySearch(endpoint client, http:Request req) {

        http:Response finderResponse;

        var params = req.getQueryParams();
        var schoolId = <string>params.schoolId;

        if (null != schoolId) {


            string studentInfoPath = "?schoolId=" + schoolId;
            var studentInfoResp = studentInfoEP->get(untaint studentInfoPath);

            xml res;
            match studentInfoResp {
                http:Response response => {
                    match (response.getXmlPayload()) {

                        xml res => {
                            log:printInfo("Student info response " + io:sprintf("%l", res));
                            finderResponse.setJsonPayload(res.toJSON({}));
                        }

                        error err => log:printError(err.message);
                    }
                }

                error err => log:printError(err.message);
            }
            _ = client->respond(finderResponse);
        }
    }
}