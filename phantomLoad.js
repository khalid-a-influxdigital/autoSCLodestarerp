var page = require('webpage').create();
var system = require('system');
var args = system.args;
var fs = require('fs');

//Script to login to lodestar, used when we've been kicked
//from the page we actually wanted.
var loginToPage = function(arg){
    var frm = document.getElementById("login-form");
    frm.elements["user_name"].value = arg[3];
    frm.elements["user_password"].value = arg[4];
    frm.elements["_token"].value = 'Yb1vz1hiBpl2ffE4wGosMRzOzjRtxfQbESiHNXnX'
    frm.submit();
}

var tabRoll = function(i){
    var list = document.getElementsByClassName("tabbed-nav")[0];
    var element = list.getElementsByTagName("a")[i];
    var event1 = document.createEvent('MouseEvents');
    event1.initMouseEvent('click', true, true, window, 1, 0, 0);
    element.dispatchEvent(event1);
}


//If this page has tabs, we'll grab the names of the tabs,
//place them in an array, then iterate.
//set one visible with a click() event, then screenshot it
//Will wait for the page to finish loading before pulling what we want
page.onLoadFinished = function(){
    console.log("args[1]= " + args[1]);
    console.log(page.title);
    //If we've been redirected to the login page then attempt
    //a login via the login script above
    if(page.title == "Lodestar"){
        console.log('Evaluating...');
        page.evaluate(loginToPage, args);
        return;
    }
    //If we've navigated to the right page, wait 5 seconds for
    //tables to load before screenshotting/pulling HTML
    else{
        if(args[5] != null){
            console.log("Clicking tab " + args[5] + "...");
            page.evaluate(tabRoll, args[5]);
        }
        window.setTimeout(function() {
            console.log('Rendering...');
            if(args[5] != null){
                page.render(args[2] + "_tab" + args[5] + ".jpg");
            }
            else{
                page.render(args[2] + '.jpg');
                console.log('Writing...');
                fs.write(args[2]+'.html',page.content,'w');
            }
            console.log('success');
            phantom.exit();
        }, 5000);
    }
}

//Get fullscreen-sized images
page.viewportSize = { width: 1920, height: 1080 };
page.open(args[1]);
