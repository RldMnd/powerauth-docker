# Getting Started

This document will help you get started with PowerAuth in just couple minutes, using deployment in [Docker](https://docs.docker.com).

## Prerequisites

- **Docker.** (version 17.3.1+) Obviously, you need Docker to use our Docker images. :-) Docker is easy to install, follow the [official documentation](https://docs.docker.com/engine/getstarted/step_one/).
- **Docker Compose.** (version 1.11.2+) Compose is an extension to Docker that simplifies container image deployment and configuration management.
- **Unix-based operating system.** While our software can run in Windows as well, we optimized our scripts for Linux / Unix environment. We proudly build all our packages on Mac OS X.

## Step By Step Start

To install PowerAuth stack in your Docker instance, perform the following steps.

There are two possible scenarios described below you can choose from:

- Full Installation
    - Get the whole PowerAuth stack Docker images which also include PowerAuth Web Flow.
    - Suitable for full deployments and quick easy testing.
- Basic Installation
    - Get the basic PowerAuth Docker images which include PowerAuth Server and PowerAuth Push Server.
    - Suitable for the use-case of the mobile banking security.

### 1. Download

First, clone the repository with Docker related files:

```sh
git clone https://github.com/wultra/powerauth-docker.git
```

### 2. Download Docker Images

Launch the following command to obtain latest versions of PowerAuth Docker images:

#### Full Installation

```sh
docker pull powerauth/server
docker pull powerauth/push-server
docker pull powerauth/server-mysql
docker pull powerauth/push-mysql
docker pull powerauth/webflow
docker pull powerauth/nextstep
docker pull powerauth/data-adapter
docker pull powerauth/webflow-mysql
```

#### Basic Installation

```sh
docker pull powerauth/server
docker pull powerauth/push-server
docker pull powerauth/server-mysql
docker pull powerauth/push-mysql
```

### 3. Configure Docker Images

If you don't do anything with the configuration, everything will just work on your local machine. However, if you need to change the Docker images (which is recommended for the production deployment), see: [Building Docker Images](./Building-Docker-Images).

### 4. Run

Run the Docker Compose in the root folder of your cloned project.

_Note: By default, the MySQL images are mounted to `/var/lib/powerauth/**` path. This path does not have to be accessible on your system. To customize MySQL instance in containers (root password, host folder mapping, etc.), you can change the related environment variables in `.env` file. You can always override these variables while launching `docker-compose up` command as well, for example to use volatile `/tmp/powerauth/**` folders. We use this trick in the following steps..._

For the full installation with volatile MySQL folders, use the following command:

```sh
cd powerauth-docker
POWERAUTH_MYSQL_PATH=/tmp/powerauth/mysql \
POWERAUTH_PUSH_MYSQL_PATH=/tmp/powerauth/mysql-push \
POWERAUTH_WEBFLOW_MYSQL_PATH=/tmp/powerauth/mysql-webflow \
docker-compose -f docker-compose-pa-all.yml up -d
```

_Note: Running whole PowerAuth stack will require at least 8 GB of RAM memory available for Docker._

For basic installation, you can use:

```sh
cd powerauth-docker
POWERAUTH_MYSQL_PATH=/tmp/powerauth/mysql \
POWERAUTH_PUSH_MYSQL_PATH=/tmp/powerauth/mysql-push \
docker-compose up -d
```

After you start the Docker images, the following databases and applications are available.

#### MySQL Databases

| Name                     | JDBC Path                                | Username | Password |
|--------------------------|------------------------------------------|----------|----------|
| PowerAuth Server DB      | `jdbc:mysql://localhost:23316/powerauth` | `root`   | `root`   |
| PowerAuth Push Server DB | `jdbc:mysql://localhost:23336/powerauth` | `root`   | `root`   |
| PowerAuth Web Flow DB    | `jdbc:mysql://localhost:23376/powerauth` | `root`   | `root    |

_Note: All databases are already created with the correct structure and contain necessary configuration._

#### Applications

| Application            | Important Paths             | URL                                                                  |
|------------------------|-----------------------------|----------------------------------------------------------------------|
| PowerAuth Server       | SOAP endpoint               | http://localhost:20010/powerauth-server/soap                         |
|                        | WSDL path                   | http://localhost:20010/powerauth-server/soap/service.wsdl            |
| PowerAuth Admin        | Web GUI                     | http://localhost:20010/powerauth-admin                               |
| PowerAuth Push Server  | Web GUI                     | http://localhost:20030/powerauth-push-server                         |
|                        | Status URL                  | http://192.168.5.107:20030/powerauth-push-server/push/service/status |
|                        | Swagger Documentation       | http://localhost:20030/powerauth-push-server/swagger-ui.html         |
| PowerAuth Web Flow     | Base URL                    | http://localhost:13030/powerauth-webflow                             |
|                        | Status URL                  | http://localhost:13030/powerauth-webflow/api/service/status          |
|                        | Swagger Documentation       | http://localhost:13030/powerauth-webflow/swagger-ui.html             |
|                        | OAuth 2.0 Authorization URL | http://localhost:13030/powerauth-webflow/oauth/authorize             |
|                        | OAuth 2.0 Token URL         | http://localhost:13030/powerauth-webflow/oauth/token                 |
|                        | User Profile Resource URL   | http://localhost:13030/powerauth-webflow/api/secure/profile/me       |
| PowerAuth Next Step    | Base URL                    | http://localhost:13010/powerauth-nextstep                            |
|                        | Swagger Documentation       | http://localhost:13010/powerauth-nextstep/swagger-ui.html            |
|                        | Status URL                  | http://localhost:13010/powerauth-nextstep/api/service/status         |
| PowerAuth Data Adapter | Base URL                    | http://localhost:13050/powerauth-data-adapter                        |
|                        | Swagger Documentation       | http://localhost:13050/powerauth-data-adapter/swagger-ui.html        |
|                        | Status URL                  | http://localhost:13050/powerauth-data-adapter/api/service/status     |

### 5. Configure System For Testing

#### 5.1 Create Mobile App Credentials

Before you create your first mobile app or customize our Mobile token app, you need to obtain the application credentials.

To do so, you need to:

1. Open PowerAuth Admin: http://localhost:20010/powerauth-admin (use `admin` username with `admin` password).
2. Enter some application name and click "Submit". We suggest using comma-separated lowercase names, such as `wultra-mtoken`.

You can now see a new application and default application version credentials:

- Master Server Public Key (application specific)
- Application Key (version specific)
- Application Secret (version specific)

These values need to be embedded in mobile application and used for PowerAuth Mobile SDK initialization.

_Note: The newly created application has also it's numeric ID - this is later referred to as `appId`._

#### 5.2 Configure Push Server

In order to configure APNs and FCM messages, you need to follow these steps:

1. Open PowerAuth Push Server Web GUI: http://localhost:20030/powerauth-push-server
2. Click "Add application".
3. Select the application you created in PowerAuth Server (`wultra-mtoken`) and click "Select".
4. Click "Configure" in APNs and FCM settings.
    - For iOS, you need to obtain the following information from the [Apple Developer Portal](https://developer.apple.com):
        - Team ID
        - Key ID
        - Bundle ID _(note: used as the "topic")_
        - APNs private key file _(note: a file with `*.p8` extension)_
    - For Android, you need to obtain the following information from the [Firebase Console]():
        - Project ID (visible in *Project Settings*) 
        - Private key for FCM HTTP API v1 (see [FCM documentation](https://firebase.google.com/docs/cloud-messaging/auth-server))     
           
To test the push notifications later, you can call the following command - don't forget to replace the `appId` and your `userId`:

```sh
curl --request POST \
  --url http://localhost:20030/powerauth-push-server/push/message/send \
  --header 'content-type: application/json' \
  --data '{
  "requestObject": {
    "appId": 1,
    "message": {
      "userId": "user123456",
      "attributes": {
        "personal": false,
        "silent": false
      },
      "body": {
        "badge": 0,
        "body": "Hello world!",
        "sound": "default",
        "title": "This is a testing push message."
      }
    }
  }
}'
```

#### 5.3 Start the Testing App

To test the complex web federated login via Web Flow, you can use our testing tool. Follow these steps:

1. Download and unpack `powerauth-webflow-testing.zip` file from the releases:
    - https://github.com/lime-company/powerauth-docker/releases
2. Review the `application.properties` file.
    - _Note: If you use the default values for the configuration, everything will just work._
    - _Note: By default, Web Flow uses a demo OAuth 2.0 credentials "democlient" / "changeme"._
3. Start the testing tool with:
    - `java -Dserver.port=8888 -XX:+IgnoreUnrecognizedVMOptions --add-modules=java.xml.bind -jar powerauth-webflow-client.war`
4. Open the testing tool on http://localhost:8888/ address.

#### 5.4 Authorize Demo Payment

You can also try to create a new payment. The default instance of Data Adapter component, that is used to customize the authentication behavior, uses the following setup:

- it accepts any username
- it maps the username to user ID (1:1)
- it uses "test" as a password for all users
- writes the SMS codes to `powerauth.da_sms_authorization` table (`authorization_code`) column of the "PowerAuth Web Flow DB" database.

Therefore, you can just submit the default form, enter any user ID as username (for example `tester`), use "test" as the password, and lookup the correct SMS code in the database.

Alternatively, you can create a payment via API - use the following command to create a new operation:

```sh
curl --request POST \
  --url http://localhost:13010/powerauth-nextstep/operation \
  --header 'content-type: application/json' \
  --data '{
  "requestObject": {
    "operationName": "authorize_payment",
    "operationId": null,
    "operationData": "A1*A100CZK*Q238400856/0300**D20170629*NUtility Bill Payment - 05/2017",
    "params": [],
    "formData": {
      "title": {
        "id": "operation.title",
        "value": null
      },
      "greeting": {
        "id": "operation.greeting",
        "value": null
      },
      "summary": {
        "id": "operation.summary",
        "value": null
      },
      "config": [],
      "parameters": [
        {
          "type": "AMOUNT",
          "id": "operation.amount",
          "label": null,
          "valueFormatType": "AMOUNT",
          "formattedValue": null,
          "amount": 100,
          "currency": "CZK",
          "currencyId": "operation.currency"
        },
        {
          "type": "KEY_VALUE",
          "id": "operation.account",
          "label": null,
          "valueFormatType": "ACCOUNT",
          "formattedValue": null,
          "value": "238400856/0300"
        },
        {
          "type": "KEY_VALUE",
          "id": "operation.dueDate",
          "label": null,
          "valueFormatType": "DATE",
          "formattedValue": null,
          "value": "2017-06-29"
        },
        {
          "type": "NOTE",
          "id": "operation.note",
          "label": null,
          "valueFormatType": "TEXT",
          "formattedValue": null,
          "note": "Utility Bill Payment - 05/2017"
        },
        {
          "type": "NOTE",
          "id": "operation.note",
          "label": null,
          "valueFormatType": "TEXT",
          "formattedValue": null,
          "note": "Utility Bill Payment - 05/2017"
        },
        {
          "type": "NOTE",
          "id": "operation.note",
          "label": null,
          "valueFormatType": "TEXT",
          "formattedValue": null,
          "note": "Utility Bill Payment - 05/2017"
        },
        {
          "type": "NOTE",
          "id": "operation.note",
          "label": null,
          "valueFormatType": "TEXT",
          "formattedValue": null,
          "note": "Utility Bill Payment - 05/2017"
        }        
      ],
      "dynamicDataLoaded": false,
      "userInput": {}
    }
  }
}'
```

The response of this command will look something like this:

```json
{
    "status": "OK",
    "responseObject": {
        "operationId": "9133b4c0-89e6-43e5-91fe-8ce8e714d1dc",
        "operationName": "authorize_payment",
        "result": "CONTINUE",
        "resultDescription": null,
        "timestampCreated": "2018-11-27T17:37:25+0000",
        "timestampExpires": "2018-11-27T17:42:25+0000",
        "operationData": null,
        "steps": [{
            "authMethod": "USER_ID_ASSIGN",
            "params": []
        }, {
            "authMethod": "USERNAME_PASSWORD_AUTH",
            "params": []
        }],
        "formData": {
            "title": {
                "id": "operation.title",
                "message": null
            },
            "greeting": {
                "id": "operation.greeting",
                "message": null
            },
            "summary": {
                "id": "operation.summary",
                "message": null
            },
            "config": [],
            "banners": [],
            "parameters": [{
                "type": "AMOUNT",
                "id": "operation.amount",
                "label": null,
                "valueFormatType": "AMOUNT",
                "formattedValue": null,
                "amount": 100,
                "currency": "CZK",
                "currencyId": "operation.currency"
            }, {
                "type": "KEY_VALUE",
                "id": "operation.account",
                "label": null,
                "valueFormatType": "ACCOUNT",
                "formattedValue": null,
                "value": "238400856/0300"
            }, {
                "type": "KEY_VALUE",
                "id": "operation.dueDate",
                "label": null,
                "valueFormatType": "DATE",
                "formattedValue": null,
                "value": "2017-06-29"
            }, {
                "type": "NOTE",
                "id": "operation.note",
                "label": null,
                "valueFormatType": "TEXT",
                "formattedValue": null,
                "note": "Utility Bill Payment - 05/2017"
            }, {
                "type": "NOTE",
                "id": "operation.note",
                "label": null,
                "valueFormatType": "TEXT",
                "formattedValue": null,
                "note": "Utility Bill Payment - 05/2017"
            }, {
                "type": "NOTE",
                "id": "operation.note",
                "label": null,
                "valueFormatType": "TEXT",
                "formattedValue": null,
                "note": "Utility Bill Payment - 05/2017"
            }, {
                "type": "NOTE",
                "id": "operation.note",
                "label": null,
                "valueFormatType": "TEXT",
                "formattedValue": null,
                "note": "Utility Bill Payment - 05/2017"
            }],
            "dynamicDataLoaded": false,
            "userInput": {}
        },
        "expired": false
    }
}
```

Copy the `operationId` value (`9133b4c0-89e6-43e5-91fe-8ce8e714d1dc`), paste it in the second tab of the testing web application (into "Operation ID" field on the "Authorization" tab) and click "Authorize" button. Proceed with login and SMS code verification as if you created a new payment via the testing web application UI.

#### 5.5 Compile and Customize Mobile Token App

_Please follow our private documentation for this step._

#### 5.6 Create a New Mobile Token Activation

To create a Mobile Token activation, you need to:

1. Open PowerAuth Admin: http://localhost:20010/powerauth-admin (use `admin` username with `admin` password).
2. Click "Activations" tab in the top navigation menu.
3. Enter any valid user ID.
    - _Note: The user ID is any unique user identifier (string) of a particular user in your system. Generally, this is the same ID that you use for the logged in user in the Internet banking, for exampe. For testing purposes, you can use arbitrary user ID, for example `tester`._
4. On the "New Activation" screen, select a desired application (`wultra-mtoken`) from the dropdown and click "Create Activation".
5. Scan the activation QR code with the mobile application that uses PowerAuth and wait for the activation to complete.
    - _Note: The mobile app needs to be compiled with the correct application credentials for this to work._
6. After the mobile app exchanges keys, refresh the page in the web browser.
    - _Note: You can use the icon next to "New Client Activation"._
7. Review the "Activation Fingerprint" and click the "Commit" button.

At this point, the cryptographic element in the Mobile token is active and ready to be used. However, you also need to set the newly created activation as the preferred one for the operation approval. To do so, you need to:

1. Copy the "Activation ID" of the committed activation from the PowerAuth Admin.
2. Call the following command from the command-line (use correct `userId` and `activationId` value):

```sh
curl --request POST \
  --url http://localhost:13010/powerauth-nextstep/user/auth-method \
  --header 'content-type: application/json' \
  --data '{
    "requestObject" : {
        "userId": "tester",
        "authMethod": "POWERAUTH_TOKEN",
        "config": {
            "activationId": "6b767ce6-bf39-40c1-956f-a2322ba6f667"
        }
    }
}'
```

If you now try to approve payment with the `tester` user, Mobile token should be offerred as an option.

####

## License

All sources are licensed using Apache 2.0 license, you can use them with no restriction. If you are using PowerAuth, please let us know. We will be happy to share and promote your project.