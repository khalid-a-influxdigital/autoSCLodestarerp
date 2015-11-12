var page = require('webpage').create();
var system = require('system');
var args = system.args;
var fs = require('fs');

//Script to login to lodestar, used when we've been kicked
//from the page we actually wanted.
//Khalid's credentials are used here.
var loginToPage = function(a){
    var frm = document.getElementById("login-form");
    frm.elements["user_name"].value = a[2];
    frm.elements["user_password"].value = a[3];
    frm.elements["_token"].value = 'Yb1vz1hiBpl2ffE4wGosMRzOzjRtxfQbESiHNXnX'
    frm.submit();
}

//Will wait for the page to finish loading before pulling what we want
page.onLoadFinished = function(){
    console.log("Finished Loading");
    console.log("args[1]= " + args[1]);
    console.log(page.title);
    //If we've been redirected to the login page then attempt
    //a login via the login script above
    if(page.title == "Lodestar"){
        console.log('Evaluating...');
        page.evaluate(loginToPage, args);
        return;
    }
    else{
    }
    console.log("Logged in");
    phantom.exit();
}

//Get fullscreen-sized images
page.open(args[1]);
