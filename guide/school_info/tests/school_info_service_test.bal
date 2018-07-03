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
// KIND, either express or implied. See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/test;
import ballerina/http;
import ballerina/io;

@test:BeforeSuite
function beforeFunc() {
    // Start the 'schoolInfo' before running the test
    _ = test:startServices("school_info");
}

// Client endpoint
endpoint http:Client clientEP {
    url: "http://localhost:9092/schoolinfo"
};

// Function to test resource 'getSchool'
@test:Config
function testResourceGetSchool() {

    // Send a 'get' request and obtain the response
    http:Response response = check clientEP->get("/34534253");
    // Expected response code is 200
    test:assertEquals(response.statusCode, 200,
        msg = "School info service did not respond with 200 OK signal!");

    // Check whether the response is as expected
    string expected = "{\"schoolId\":34534253,\"name\":\"School ABC\",\"address\":\"344 Scarbrough Ln, Cordova,"
        + " TN 12111\",\"principal\":\"John Due\"}";

    json resPayload = check response.getJsonPayload();
    io:print(resPayload);
    test:assertEquals(resPayload.toString(), expected, msg = "Response mismatch!");
}

@test:AfterSuite
function afterFunc() {
    // Stop the 'schoolInfo' after running the test
    test:stopServices("school_info");
}