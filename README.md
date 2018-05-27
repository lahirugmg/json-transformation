# XML to JSON

XML(Extensible Markup Language) and JSON(JavaScript Object Notation) are widely used formats for structuring data for web services. How to converting a message from XML to JSON and handling data types in JSON out put are an important aspect of integration language.

> In this guide you will learn about conversion of message from XML to JSON and important aspects when handling data types in JSON using Ballerina. 

The following are the sections available in this guide.

- [What you'll build](#what-youll-build)

## What you’ll build 

To understanding how you can convert XML form to JSON and handle data types in JSON using Ballerina, let’s consider a real world use case of a student information service. Student-finder is a composition service which integrates data from student-info and school-info services. Student-info service may return details of single or multiple sets of students in XML format. School-info service returns detals of a particular school in JSON format.
