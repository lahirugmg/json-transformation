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


endpoint http:Listener studentInfoListener {
    port: 9091
};

// Student info service.
@http:ServiceConfig { basePath: "/studentinfo" }
service<http:Service> studentInfo bind studentInfoListener {

    // Resource that handles the HTTP GET requests that are directed to a specific
    // student using path '/student/<studentId>'
    @http:ResourceConfig {
        methods: ["GET"],
        path: "/{studentId}"
    }

    getStudent(endpoint client, http:Request req, string studentId) {
        http:Response response;
        xml studentDetails;
        // Mock logic
        // Details of the student
        if ("0989898" == studentId) {
            studentDetails = getStudentAsXml(studentId, "34534253", "Edwin", "Tyler", "09/01/2015", 2012, true);
        } else if ("45675647" == studentId) {
            studentDetails = getStudentAsXml(studentId, "34534253", "Angele", "Marburger", "09/02/2015", 2012, true);
        } else if ("78687765" == studentId) {
            studentDetails = getStudentAsXml(studentId, "34534253", "Ming", "Gower", "09/03/2015", 2013, true);
        } else if ("54667677" == studentId) {
            studentDetails = getStudentAsXml(studentId, "34534253", "Ervin", "Rappa", "09/04/2015", 2013, false);
        } else if ("00676676" == studentId) {
            studentDetails = getStudentAsXml(studentId, "78575456", "Roni", "Rabideau", "09/05/2015", 2012, true);
        } else if ("11335556" == studentId) {
            studentDetails = getStudentAsXml(studentId, "78575456", "Wendolyn", "Haber", "09/06/2015", 2012, true);
        } else if ("00827223" == studentId) {
            studentDetails = getStudentAsXml(studentId, "78575456", "Yuonne", "Braman", "09/07/2015", 2013, false);
        } else if ("99876655" == studentId) {
            studentDetails = getStudentAsXml(studentId, "98071230", "Sherlene", "Melrose", "09/08/2015", 2012, true);
        } else if ("09244894" == studentId) {
            studentDetails = getStudentAsXml(studentId, "98071230", "Felisa", "Schram", "09/09/2015", 2012, true);
        } else if ("89874378" == studentId) {
            studentDetails = getStudentAsXml(studentId, "98071230", "Tracy", "Larose", "09/10/2015", 2013, false);
        } else if ("74723723" == studentId) {
            studentDetails = getStudentAsXml(studentId, "98071230", "Creola", "Stanback", "09/11/2015", 2013, true);
        } else if ("09283838" == studentId) {
            studentDetails = getStudentAsXml(studentId, "54767688", "Karri", "Dubinsky", "09/12/2015", 2012, false);
        } else if ("83282889" == studentId) {
            studentDetails = getStudentAsXml(studentId, "54767688", "Juli", "Shelman", "09/13/2015", 2012, true);
        } else if ("92398238" == studentId) {
            studentDetails = getStudentAsXml(studentId, "54767688", "Shelli", "Clemmons", "09/14/2015", 2013, true);
        } else if ("76656555" == studentId) {
            studentDetails = getStudentAsXml(studentId, "54767688", "Raymonde", "Drane", "09/15/2015", 2013, true);
        }

        // Response payload
        response.setXmlPayload(studentDetails);
        // Send the response to the caller
        _ = client->respond(response);
    }

    // Resource that handles the HTTP GET requests that are used to search student with query parametr School Id
    // using path '/student'
    @http:ResourceConfig {
        methods: ["GET"],
        path: "/students"
    }
    getStudentBySearch(endpoint client, http:Request req) {

        http:Response response;

        var params = req.getQueryParams();
        var schoolId = <string>params.schoolId;
        var addmissionYear = <string>params.addmissionYear;
        xml studentsDetails;
        if (null != schoolId) {
            if ("34534253" == schoolId) {
                studentsDetails = xml `<studentsDetails>
                        {{getStudentAsXml("0989898", schoolId, "Edwin", "Tyler", "09/01/2015", 2012, true)}}
                        {{getStudentAsXml("45675647", schoolId, "Angele", "Marburger", "09/02/2015", 2012, true)}}
                        {{getStudentAsXml("78687765", schoolId, "Ming", "Gower", "09/03/2015", 2013, true)}}
                        {{getStudentAsXml("54667677", schoolId, "Ervin", "Rappa", "09/04/2015", 2013, false)}}
                </studentsDetails>`;
            } else if ("78575456" == schoolId) {
                studentsDetails = xml `<studentsDetails>
                        {{getStudentAsXml("00676676", schoolId, "Roni", "Rabideau", "09/05/2015", 2012, true)}}
                        {{getStudentAsXml("11335556", schoolId, "Wendolyn", "Haber", "09/06/2015", 2012, true)}}
                        {{getStudentAsXml("00827223", schoolId, "Yuonne", "Braman", "09/07/2015", 2013, false)}}
                </studentsDetails>`;
            } else if ("98071230" == schoolId) {
                studentsDetails = xml `<studentsDetails>
                        {{getStudentAsXml("99876655", schoolId, "Sherlene", "Melrose", "09/08/2015", 2012, true)}}
                        {{getStudentAsXml("09244894", schoolId, "Felisa", "Schram", "09/09/2015", 2012, true)}}
                        {{getStudentAsXml("89874378", schoolId, "Tracy", "Larose", "09/10/2015", 2013, false)}}
                        {{getStudentAsXml("74723723", schoolId, "Creola", "Stanback", "09/11/2015", 2013, true)}}
                </studentsDetails>`;
            } else if ("54767688" == schoolId) {
                studentsDetails = xml `<studentsDetails>
                        {{getStudentAsXml("09283838", schoolId, "Karri", "Dubinsky", "09/12/2015", 2012, false)}}
                        {{getStudentAsXml("83282889", schoolId, "Juli", "Shelman", "09/13/2015", 2012, true)}}
                        {{getStudentAsXml("92398238", schoolId, "Shelli", "Clemmons", "09/14/2015", 2013, true)}}
                        {{getStudentAsXml("76656555", schoolId, "Raymonde", "Drane", "09/15/2015", 2013, true)}}
                </studentsDetails>`;
            }
        } else if (null != addmissionYear) {
            if ("2012" == addmissionYear) {
                studentsDetails = xml `<studentsDetails>
                        {{getStudentAsXml("0989898", schoolId, "Edwin", "Tyler", "09/01/2015", 2012, true)}}
                        {{getStudentAsXml("45675647", schoolId, "Angele", "Marburger", "09/02/2015", 2012, true)}}
                        {{getStudentAsXml("00676676", schoolId, "Roni", "Rabideau", "09/05/2015", 2012, true)}}
                        {{getStudentAsXml("11335556", schoolId, "Wendolyn", "Haber", "09/06/2015", 2012, true)}}
                        {{getStudentAsXml("99876655", schoolId, "Sherlene", "Melrose", "09/08/2015", 2012, true)}}
                        {{getStudentAsXml("09244894", schoolId, "Felisa", "Schram", "09/09/2015", 2012, true)}}
                        {{getStudentAsXml("09283838", schoolId, "Karri", "Dubinsky", "09/12/2015", 2012, false)}}
                        {{getStudentAsXml("83282889", schoolId, "Juli", "Shelman", "09/13/2015", 2012, true)}}
                </studentsDetails>`;
            } else if ("2013" == addmissionYear) {
                studentsDetails = xml `<studentsDetails>
                        {{getStudentAsXml("78687765", schoolId, "Ming", "Gower", "09/03/2015", 2013, true)}}
                        {{getStudentAsXml("54667677", schoolId, "Ervin", "Rappa", "09/04/2015", 2013, false)}}
                        {{getStudentAsXml("00827223", schoolId, "Yuonne", "Braman", "09/07/2015", 2013, false)}}
                        {{getStudentAsXml("89874378", schoolId, "Tracy", "Larose", "09/10/2015", 2013, false)}}
                        {{getStudentAsXml("74723723", schoolId, "Creola", "Stanback", "09/11/2015", 2013, true)}}
                        {{getStudentAsXml("92398238", schoolId, "Shelli", "Clemmons", "09/14/2015", 2013, true)}}
                        {{getStudentAsXml("76656555", schoolId, "Raymonde", "Drane", "09/15/2015", 2013, true)}}
                </studentsDetails>`;
            }
        }

        // Response payload
        response.setXmlPayload(studentsDetails);
        // Send the response to the caller
        _ = client->respond(response);
    }
}

function getStudentAsXml(string studentId, string firstName, string lastName, string schoolId, string birthDate,
                         int addmissionYear, boolean usCitizen) returns xml {
    xml studentDetails = xml `<student>
                        <studentId>{{studentId}}</studentId>
                        <schoolId>{{schoolId}}</schoolId>
                        <firstName>{{firstName}}</firstName>
                        <lastName>{{lastName}}</lastName>
                        <birthDate>{{birthDate}}</birthDate>
                        <addmissionYear>{{addmissionYear}}</addmissionYear>
                        <usCitizen>{{usCitizen}}</usCitizen>
                    </student>`;
    return studentDetails;
}


