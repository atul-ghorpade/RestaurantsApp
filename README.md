# RestaurantsApp
MVP-Clean sample iOS Swift project

The purpose of this document is to explain the architecture of application.

This application shows restaurants nearby to user's current location.
It has feature to show those restaurants locations on map. Also, on tap of list row or map annotation, restaurant details are shown.
User can start map navigation to restaurant from details screen.

Below are running app screenshots:


![list](https://user-images.githubusercontent.com/4067755/147441550-56350119-9215-4e7a-aa5f-78b00f14a45c.png) ![map](https://user-images.githubusercontent.com/4067755/147441623-2f16cf48-31f1-484f-8b76-7403060c2175.png) 

![details](https://user-images.githubusercontent.com/4067755/147441670-ed128ab6-0a11-484c-a4eb-4d91d6e46351.png)  ![navigation](https://user-images.githubusercontent.com/4067755/147441693-5c8025e3-0150-4ac3-a09b-8b0aa56af7a2.png) ![error](https://user-images.githubusercontent.com/4067755/147441711-1bddb22a-07d0-4bd6-acf9-bd79d58f19d4.png)
![pagination](https://user-images.githubusercontent.com/4067755/147441744-06692383-0209-48b6-906c-2f4940a572b9.gif)


## Table of Contents
1. Architecture
2. Implementation
3. Testing
4. Project Setup
5. Notes
6. Pending Improvements (// TODOs)

## 1. Architecture
The project is divided into different folder which act as logical units. Each unit has its own responsibility and behaviour. All components communication is done using abstraction. 
This app divided into below folder structure:

<img width="230" alt="folders" src="https://user-images.githubusercontent.com/4067755/147441925-7cf04a6f-160a-4a94-9bbd-ce46a4b21d3a.png">


This diagram will illustrate high level implementation of architecture(3 + 1 architecture)
<img width="404" alt="architecture" src="https://user-images.githubusercontent.com/4067755/147442126-a0e16c53-571e-42ce-b441-fba50cfaf7b7.png">

### Presentation:
Responsible to handle all user events on view.
It consist below things:

***Presenter***:
It is responsible to update the result of business logic to viewController. this update is handled using viewState binding.

***ViewController***: It links the user controls to update them when needed. View will inform presenter about user action.

### Domain:

Handler of all business logic and models.
It consist below things:

***Models***: Models are Entities domain model representation.

***UseCases***: It is responsible to handle use case and business logic. Protocols and their implementations to represent business logics

***ProviderProtocols***: These are Protocol which can be confirmed in data layer.

### Data:
Responsible to retrieve all the data required by the application.
It consist below things:

***Entities***: It defines structs for responses representation.

***Services***: Service layer is for getting the data through data source, in this case it is network.

***Providers***: It handle sthe services and retrieve the data from services and updates domain model about the data.

### App:
Responsible to manage app level responibilities.
It consist below things:

***Routers***: It defines and implements all the navigation logic.

***Builder***: Builders is used for injecting dependencies across modules.


## 2. Implementation
To develop this, MVP-CLEAN architecture is used.


## 3. Testing
* Under PresentationTests, there are unit test cases for Presenters.
* Under DomainTests, there are unit test cases for Models and UseCases.
* Under DataTests, there are unit test cases for Repositories.


## 4. Project Setup
To run this project on a local machine follow below steps:

* Inside /Restaurants/Restaurants/Data/Services/NetworkServiceConstants.swift, assign valid Google API key with places API enabled to constant `apiKey`
* Open Restaurants.xcodeproj file in Xcode 13.x version and run it on the simulator.
* For simulator, simulate desired location.

## 5. Notes
* RestarantsParent to List and Map communication is done through Router. To achieve this childViews are added through Router to enable presenter-presenter communication. There are other simple ways availble like parent-child View-View communication but it forces us to pass domain models from parent view to child view.

## 6. Pending Improvements (// TODOs)
* Improve async image loading in RestaurantTableViewCell. Add implementation to handle cancellation of image downloading. 
* Improve overall test code coverage.
* Decouple presenters from LocationManager
* Create dynamic frameworks for each layer.
* Create Xcode templates to repeat this code structure easily.
