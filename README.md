# XML to JSON

XML(Extensible Markup Language) and JSON(JavaScript Object Notation) are widely used formats for structuring data for web services. How to converting a message from XML to JSON and handling data types in JSON out put are an important aspect of integration language.

> In this guide you will learn about conversion of message from XML to JSON and important aspects when handling data types in JSON using Ballerina. 

The following are the sections available in this guide.

- [What you'll build](#what-youll-build)

## What you’ll build 

To understanding how you can convert XML form to JSON and handle data types in JSON using Ballerina, let’s consider a real world use case of a student information service. Student-finder is a composition service which integrates data from student-info and school-info services. Student-info service may return details of single or multiple sets of students in XML format. School-info service returns detals of a particular school in JSON format.


## Prerequisites
 
- [Ballerina Distribution](https://ballerina.io/learn/getting-started/)
- A Text Editor or an IDE 

### Optional requirements
- Ballerina IDE plugins ([IntelliJ IDEA](https://plugins.jetbrains.com/plugin/9520-ballerina), [VSCode](https://marketplace.visualstudio.com/items?itemName=WSO2.Ballerina), [Atom](https://atom.io/packages/language-ballerina))
- [Docker](https://docs.docker.com/engine/installation/)
- [Kubernetes](https://kubernetes.io/docs/setup/)

## Implementation

> If you want to skip the basics, you can download the git repo and directly move to the "Testing" section by skipping  "Implementation" section.

Ballerina is a complete programming language that supports custom project structures. Use the following package structure for this guide.

```
restful-service
 └── guide
      ├── school-info
      |     └── school_info.bal 
      ├── student-info
      |     └── student_info.bal
      └── xml-to-json
            └── student_finder.bal  
```

- Create the above directories in your local machine and also create empty `.bal` files.

- Then open the terminal and navigate to `xml-to-json/guide` and run Ballerina project initializing toolkit.
```bash
   $ ballerina init
```

### Developing the service

- We can get started with a Ballerina service; 'school_info', which works as a backend to the actual integration service. This service returns information of the School corresponding to the schoolId passed via path parameter.

- Second backend service is; 'student_info', which responds with student information based on different parameters passed. 
