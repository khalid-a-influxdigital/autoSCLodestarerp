#!/bin/bash

#A few important filepaths
pLoad=~/Desktop/autoSC/phantomLoad.js
oLoad=~/Desktop/autoSC/otherPageLoad.js
cook=~/Desktop/autoSC/cookez
pLogin=~/Desktop/autoSC/phantomLogin.js

#Reinitialize cookie for each user, enter site, and take screenshots
function phantom_grab()
{
  #Set cookies by logging in
  echo "Logging in as $1"
  phantomjs --cookies-file=$cook $pLogin https://lodestarerp.com $1 $2 &>/dev/null

  echo "screenshotting..."
  mkdir lodestar_dashboard
  cd lodestar_dashboard
  curling dashboard dashboard
  mkdir midi flcstr pgtr
  cd midi  
  curling midigator/dashboard midiDashboard $1 $2
  curling midigator/analytics midiAnalytics $1 $2
  mkdir account_tabs
  cd account_tabs
  curling midigator/accounts midiAccounts $1 $2
  curling midigator/accounts midiAccounts $1 $2 1
  curling midigator/accounts midiAccounts $1 $2 2
  curling midigator/accounts midiAccounts $1 $2 3
  echo "Patience is a virtue :) ..."
  cd ..
  mkdir manager_tabs
  cd manager_tabs
  curling midigator/manager midiManager $1 $2 
  curling midigator/manager midiManager $1 $2 1
  curling midigator/manager midiManager $1 $2 2
  curling midigator/manager midiManager $1 $2 3
  cd ..
  mkdir ppackage_tabs
  cd ppackage_tabs
  curling midigator/presentmentpackage midiPPackage $1 $2
  curling midigator/presentmentpackage midiPPackage $1 $2 1
  cd ..
  curling midigator/\help \help $1 $2
  curling midigator/profile profile $1 $2
  
  cd ..
  cd ..
  cd ..
  echo "Done. Moving to next user."
}

#Helper method to grab pages specific to the lode_admin
function phantom_admin_grab()
{
  mkdir admin
  cd admin

  curling admin admin_main $1 $2
  curling admin/accounts admin_accounts $1 $2
  curling admin/companies admin_companies $1 $2
  curling admin/crms admin_crms $1 $2
  curling admin/jobqueue admin_jobqueue $1 $2

  cd ..
  cd ..
}

#Helper method for curl_grab
#Grab HTML from website, add absolute paths to images, and screenshot locally
#Mind the 5-second delay now, it's to make sure the tables have loaded on the website
function curling(){
  phantomjs --cookies-file=$cook $pLoad https://lodestarerp.com/$1 $2 $3 $4 $5 &>/dev/null 
  sed -i.bak "s|href=/|href=https://lodestarerp.com|" $2.html
  rm $2.html.bak
  
}  

#Decide on path to store screenshots and folders
echo "Preparing to screenshot lodestarerp.com"
canMove=0
while [ $canMove -ne 1 ]; do
echo "Place images in current directory?(Y/N)"
read SEL
if [ "$SEL" == "Y" ]; then
  DST=""
  canMove=1
elif [ "$SEL" == "N" ]; then
  echo "Provide full path to dir where captures go (don't use \` shortcuts):"
  read path
  DST=path
  canMove=
  if cd $path; then
    echo "Screenshotting into $path"
    mkdir auto_screenshots
    cd auto_screenshots
  else
    echo "Invalid path, try again"
    canMove=0
  fi 

else
  echo "Response was not valid, run program again"
  canMove=0
fi
done

#Directories we'll place our screenshots in, nice and tidy
mkdir splashpage_SC lode_admin mid_admin mid_user
cd splashpage_SC

#Grab screenshot of splashpage
curl -s -o splash.html https://lodestarerp.com
sed -i.bak "s|hideme|hideme\" style=\"opacity: 1;|" splash.html
sed -i.bak "s|img src=\"/|img src=\"https://lodestarerp.com/|" splash.html
sed -i.bak '/wow.js/d' splash.html
phantomjs $oLoad splash.html splash &>/dev/null

#Grab screenshot of login page  
curl -s -o login_page.html https://lodestarerp.com/login
sed -i.bak "s|img src=\"|img src=\"https://lodestarerp.com/|" login_page.html
phantomjs $oLoad login_page.html login_page &>/dev/null

#Grab screenshot of learnmore page
curl -s -o learnmore.html https://lodestarerp.com/learnmore/midigator
sed -i.bak '/wow.js/d' learnmore.html
phantomjs $oLoad learnmore.html learnmore &>/dev/null
rm *.bak

#Populate folders with screenshots
cd ..
cd lode_admin
phantom_grab kalmande Adboom123
cd lode_admin
phantom_admin_grab kalmande Adboom123

cd mid_admin
phantom_grab anna@lodestarerp.com Jellybean1

cd mid_user
phantom_grab qa1@adboomgrp.com Adboom456

echo "Screenshotting done."



