# GetHuman AWS OpsWorks Cookbook

## Recipes
![](http://new.tinygrab.com/d53b50c2062ff8f3bb230fe32a72fdb7dc3bc81fb0.png)

![](http://new.tinygrab.com/d53b50c20626a1a609fd55b5eaceab143307616cd6.png)

### gethuman
  The default Chef Recipe
  https://github.com/snuggs/airpair-cookbooks/blob/master/gethuman/recipes/default.rb

### gethuman::caching
  nginx page caching - Modify chef cookbook to enable page caching. Document how we can easily modify the routes to be cached and length of time for caching.

#### Route Caching

#### Duration

### gethuman::ssl
  All requests MUST redirect to the SSL (https) version of the site.
  The following domains are the only exception:
  - gethuman.com
  - *.gethuman.com
  - gethuman.co
  - *.gethuman.co

### gethuman::log
  logs to CloudWatch - Right now just logging locally (see opsworks_nodejs/templates/default/node_web_app.monitrc.erb). We want to send this production.log from every instance as well as any other relevant logs you think makes sense to CloudWatch.

### gethuman::nodejs
Restart node.js process
Note: _This script does not run config/setup steps that are in opsworks_

Select specific instances to restart

A common use case for this would involve querying
which instances are currently active through the CLI and
then looping through that list and restarting node.js one at a time
with 5 second pauses (i.e. cycle through all instances)


https://github.com/Unitech/PM2/blob/master/ADVANCED_README.md

http://stackoverflow.com/questions/11275870/how-can-i-automatically-start-a-node-js-application-in-amazon-linux-ami-on-aws
https://forums.aws.amazon.com/message.jspa?messageID=569282

## Environment Variables
  This cookbook provides the following updates to environment variables:
  Please refer to the following for more attribute precedence details
  http://docs.aws.amazon.com/opsworks/latest/userguide/workingcookbook-attributes-precedence.html

### Chef Cookbook Attributes
  Location: https://github.com/snuggs/airpair-cookbooks/blob/master/gethuman/attributes/custom.rb

  Should have developers be able to put in environment variables.

  Uses the override attribute strategy
  ![](http://new.tinygrab.com/d53b50c206bb5105c4802506f20afcf050b50c0799.png)


### AWS Opsworks Console
   Should have administrators be able to put in custom jSON which overrides.
![](http://new.tinygrab.com/d53b50c206e6b3cf28669e18c4637365e4ed29de77.png)

### Custom JSON
  This setting is located within AWS OpsWorks console under Deploy App. The variables set here take the highest precedence of all settings.

```javascript
{
  // All instance environment variables:
  "environment_variables": {
    "PRIVATE": "SECRETZ"
  },

  // Specific instance environment variables:
  "deploy": {
    "app_name": {
      "environment_variables": {
        "PRIVATE": "SECRETZ"
      }
    }
  }
}
```

** Notes
![](http://new.tinygrab.com/d53b50c206be7ac1d60b4c7eff00ae7846d720afb1.png)
* WE NEED To get the repository as a fork atop aws/opsworks-cookbooks/
  in the following blog post discusses how include_attribute is deprecated. However aws/opsworks-cookbooks uses this.
  Expect a major deprecation coming soon.

  https://www.chef.io/blog/2013/02/05/chef-11-in-depth-attributes-changes/

## Rollback
  Use AWS Opsworks Console to rollback to previous versions.
  Deployments -> Deploy -> Rollback
  ![](http://new.tinygrab.com/d53b50c206d3f780ea90b51f2723ff5a737c5ebe3d.png)

  When the app is updated, AWS OpsWorks stores the previous version, up to a maximum of five versions. You can use this command to roll an app back as many as four versions.

## Zero Downtime
  One nicety of AWS Opsworks is the apps do not fail over on redeploy. The current application will run all the way until the new instance is fully loaded.

http://www.guywarner.com/2014/12/zero-downtime-rolling-deploy-with-aws.html

You should not write this in JavaScript. Rather, if you can do something similar through the AWS CLI with a series of commands, I can take what you give me a stick it into a JavaScript script.

## Node Version Management
  Set things up so I can easily switch back and forth between io.js, node.js and different versions of each. I want to try testing out between node 0.10, node 0.12 and the latest io.js

  As of 2015-04-01 only node v0.10 is supported on AWS Opsworks. However, there are a few alternatives to getting the latest version of node installed:

  - Custom ALI http://github.com/zupper/nodejs-wrapper-psworks
  - Custom Ubuntu installation. (Sounds more difficult than it really is) http://serverfault.com/questions/674089/how-can-i-get-node-js-0-12-0-running-on-aws-opsworks
  - Custom AWS Opsworks layer

