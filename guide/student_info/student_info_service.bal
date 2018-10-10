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

import ballerina/http;
import ballerina/io;
import ballerina/log;


// Map of type Student. Keeps the mock data to cater
map<Student> studentMap = {
    "1989898": new(1989898, "34534253", "Edwin", "Tyler", "09/01/2006", 2012, true),
    "45675647": new(45675647, "34534253", "Angele", "Marburger", "09/02/2006", 2012, true),
    "78687765": new(78687765, "34534253", "Ming", "Gower", "09/03/2006", 2013, true),
    "54667677": new(54667677, "34534253", "Ervin", "Rappa", "09/04/2006", 2013, false),
    "10676676": new(10676676, "78575456", "Roni", "Rabideau", "09/05/2006", 2012, true),
    "11335556": new(11335556, "78575456", "Wendolyn", "Haber", "09/06/2006", 2012, true),
    "10827223": new(10827223, "78575456", "Yuonne", "Bradman", "09/07/2006", 2013, false),
    "99876655": new(99876655, "98071230", "Sherlene", "Melrose", "09/08/2006", 2012, true),
    "19244894": new(19244894, "98071230", "Felisa", "Schram", "09/09/2006", 2012, true),
    "89874378": new(89874378, "98071230", "Tracy", "Larose", "09/10/2006", 2013, false),
    "74723723": new(74723723, "98071230", "Creola", "Stanback", "09/11/2006", 2013, true),
    "19283838": new(19283838, "54767688", "Karri", "Dubinsky", "09/12/2006", 2012, false),
    "82020234": new(82020234, "54767688", "Juli", "Shelman", "09/13/2006", 2012, true),
    "92398238": new(92398238, "54767688", "Shelli", "Clemmons", "09/14/2006", 2013, true),
    "76656555": new(76656555, "54767688", "Raymonde", "Drane", "09/15/2006", 2013, true)
};

// Defines the Student object
type Student object {
    int studentId;
    string schoolId;
    string firstName;
    string lastName;
    string birthDate;
    int addmissionYear;
    boolean usCitizen;

    // Constructor that can be used to initialize the object
    new(studentId, schoolId, firstName, lastName, birthDate, addmissionYear, usCitizen) {
    }
};

endpoint http:Listener studentInfoListener {
    port: 9091
};

// Student info service.
@http:ServiceConfig {
    basePath: "/studentinfo"
}
service<http:Service> studentInfoService bind studentInfoListener {

    // Resource that handles the HTTP GET requests that are directed to a specific
    // student using path '/student/<studentId>'
    @http:ResourceConfig {
        methods: ["GET"],
        path: "/{studentId}"
    }

    get(endpoint client, http:Request req, string studentId) {
        http:Response response;

        // Details of the student are extracted from the map
        try {
            response.setXmlPayload(check getStudentAsXml(studentMap[studentId]));

        } catch (error err) {

            response.setXmlPayload(xml `<error>Student not found</error>`);
            response.statusCode = 404;
            log:printError(err.message);
        }
        // Send the response to the caller
        _ = client->respond(response);
    }



    // Resource that handles the HTTP GET requests that are used to search student with query parametr school Id or addmission year
    // using path '/student'
    @http:ResourceConfig {
        methods: ["GET"],
        path: "/*"
    }
    getStudentBySearch(endpoint client, http:Request req) {

        http:Response response;
        var params = req.getQueryParams();
        xml studentsDetails;

        if (params.hasKey("schoolId")) {

            string schoolId = params.schoolId;

            if ("34534253" == schoolId) {
                studentsDetails = xml `<studentsDetails>
                                        {{check getStudentAsXml(studentMap["1989898"])}}
                                        {{check getStudentAsXml(studentMap["45675647"])}}
                                        {{check getStudentAsXml(studentMap["78687765"])}}
                                        {{check getStudentAsXml(studentMap["54667677"])}}
                                </studentsDetails>`;
                // Set XML to the response payload
                response.setXmlPayload(untaint studentsDetails);

            } else if ("78575456" == schoolId) {
                studentsDetails = xml `<studentsDetails>
                                        {{check getStudentAsXml(studentMap["10676676"])}}
                                        {{check getStudentAsXml(studentMap["11335556"])}}
                                        {{check getStudentAsXml(studentMap["10827223"])}}
                                </studentsDetails>`;
                // Set XML to the response payload
                response.setXmlPayload(untaint studentsDetails);

            } else if ("98071230" == schoolId) {
                studentsDetails = xml `<studentsDetails>
                                        {{check getStudentAsXml(studentMap["99876655"])}}
                                        {{check getStudentAsXml(studentMap["19244894"])}}
                                        {{check getStudentAsXml(studentMap["89874378"])}}
                                        {{check getStudentAsXml(studentMap["74723723"])}}
                                </studentsDetails>`;
                // Set XML to the response payload
                response.setXmlPayload(untaint studentsDetails);

            } else if ("54767688" == schoolId) {
                studentsDetails = xml `<studentsDetails>
                                        {{check getStudentAsXml(studentMap["19283838"])}}
                                        {{check getStudentAsXml(studentMap["82020234"])}}
                                        {{check getStudentAsXml(studentMap["92398238"])}}
                                        {{check getStudentAsXml(studentMap["76656555"])}}
                                </studentsDetails>`;
                // Set XML to the response payload
                response.setXmlPayload(untaint studentsDetails);

            } else {

                response.setXmlPayload(xml `<error>School not found</error>`);
                response.statusCode = 404;
            }

        } else if (params.hasKey("addmissionYear")) {

            try {
                int addmissionYear = check <int>params.addmissionYear;

                if (2012 == addmissionYear) {
                    studentsDetails = xml `<studentsDetails>
                    {{check getStudentAsXml(studentMap["1989898"])}}
                    {{check getStudentAsXml(studentMap["45675647"])}}
                    {{check getStudentAsXml(studentMap["10676676"])}}
                    {{check getStudentAsXml(studentMap["11335556"])}}
                    {{check getStudentAsXml(studentMap["99876655"])}}
                    {{check getStudentAsXml(studentMap["19244894"])}}
                    {{check getStudentAsXml(studentMap["19283838"])}}
                    {{check getStudentAsXml(studentMap["82020234"])}}
                    </studentsDetails>`;
                    // Set XML to the response payload
                    response.setXmlPayload(untaint studentsDetails);
                } else if (2013 == addmissionYear) {
                    studentsDetails = xml `<studentsDetails>
                    {{check getStudentAsXml(studentMap["78687765"])}}
                    {{check getStudentAsXml(studentMap["54667677"])}}
                    {{check getStudentAsXml(studentMap["10827223"])}}
                    {{check getStudentAsXml(studentMap["89874378"])}}
                    {{check getStudentAsXml(studentMap["74723723"])}}
                    {{check getStudentAsXml(studentMap["92398238"])}}
                    {{check getStudentAsXml(studentMap["76656555"])}}
                    </studentsDetails>`;
                    // Set XML to the response payload
                    response.setXmlPayload(untaint studentsDetails);
                } else {

                    response.setXmlPayload(xml `<error>Addmission year not found</error>`);
                    response.statusCode = 404;
                }
            } catch (error err) {
                log:printError("Error occurred while preparing addmission year based response, Error: " + err.message);
            }
        }

        // Send the response to the caller
        _ = client->respond(response);
    }
}

function getStudentAsXml(Student? student) returns xml|error {

        match student {

            Student std => {
                xml studentDetails = xml `<student>
                                    <studentId>{{std.studentId}}</studentId>
                                    <schoolId>{{std.schoolId}}</schoolId>
                                    <firstName>{{std.firstName}}</firstName>
                                    <lastName>{{std.lastName}}</lastName>
                                    <birthDate>{{std.birthDate}}</birthDate>
                                    <addmissionYear>{{std.addmissionYear}}</addmissionYear>
                                    <usCitizen>{{std.usCitizen}}</usCitizen>
                                </student>`;
                return studentDetails;
            }
            () => {
                error err = { message: "Student is not found" };
                return err;
            }
        }
}
