Iquidus Explorer - 1.7.4
================

An open source block explorer written in node.js.

### See it in action

*  [List of live explorers running Iquidus](https://github.com/garyyue2019/explorer/wiki/Live-Explorers)


*Note: If you would like your instance mentioned here contact me*

### Requires

*  node.js >= 8.17.0 (12.14.0 is advised for updated dependencies)
*  mongodb 4.2.x
*  *coind

### Install node https://nodejs.org/dist/v12.2.0/node-v12.2.0-x64.msi
sudo apt -y install curl dirmngr apt-transport-https lsb-release ca-certificates 
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash - 
sudo apt install nodejs
### Install mongodb

$ echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb.list
 sudo apt update
 
 sudo apt install mongodb-org=4.0.1 mongodb-org-server=4.0.1 mongodb-org-shell=4.0.1 mongodb-org-mongos=4.0.1 mongodb-org-tools=4.0.1
 或
sudo apt-get install mongodb
查看版本
mongod --version
对mongoDB Server的管理
sudo systemctl enable mongod 
sudo systemctl start mongod

关闭mongodb日志

进入所在库，将慢查询的数字设成足够大即可，如下面设置成5万毫秒，就是说只有超过5万毫秒的才会打印日志了

> db.setProfilingLevel(1,50000)

{"was":0,"slowms":100,"ok":1}

>db.setProfilingLevel(0)

{"was":1,"slowms":50000,"ok":1}
————————————————


### Create database

Enter MongoDB cli:

    $ mongo

Create databse:

    > use explorerdb

Create user with read/write access:

    > db.createUser( { user: "iquidus", pwd: "3xp!0reR", roles: [ "readWrite" ] } )

*Note: If you're using mongo shell 4.2.x, use the following to create your user:

    > db.addUser( { user: "username", pwd: "password", roles: [ "readWrite"] })

### Get the source
   npm config set registry https://registry.npm.taobao.org

    git clone https://github.com/garyyue2019/explorer explorer

### Install node modules

    cd explorer && npm install --production

### Configure

    cp ./settings.json.template ./settings.json

*Make required changes in settings.json*

### Start Explorer

    npm start

*Note: mongod must be running to start the explorer*

As of version 1.4.0 the explorer defaults to cluster mode, forking an instance of its process to each cpu core. This results in increased performance and stability. Load balancing gets automatically taken care of and any instances that for some reason die, will be restarted automatically. For testing/development (or if you just wish to) a single instance can be launched with

    node --stack-size=10000 bin/instance

To stop the cluster you can use

    npm stop

### Syncing databases with the blockchain

sync.js (located in scripts/) is used for updating the local databases. This script must be called from the explorers root directory.

    Usage: node scripts/sync.js [database] [mode]

    database: (required)
    index [mode] Main index: coin info/stats, transactions & addresses
    market       Market data: summaries, orderbooks, trade history & chartdata

    mode: (required for index database only)
    update       Updates index from last sync to current block
    check        checks index for (and adds) any missing transactions/addresses
    reindex      Clears index then resyncs from genesis to current block

    notes:
    * 'current block' is the latest created block when script is executed.
    * The market database only supports (& defaults to) reindex mode.
    * If check mode finds missing data(ignoring new data since last sync),
      index_timeout in settings.json is set too low.


*It is recommended to have this script launched via a cronjob at 1+ min intervals.*

**crontab**

*Example crontab; update index every minute and market data every 2 minutes*

    */1 * * * * cd /path/to/explorer && /usr/bin/node scripts/sync.js index update > /dev/null 2>&1
    */2 * * * * cd /path/to/explorer && /usr/bin/node scripts/sync.js market > /dev/null 2>&1
    */5 * * * * cd /path/to/explorer && /usr/bin/node scripts/peers.js > /dev/null 2>&1
    
可以尝试 node --stack-size=10000 scripts/sync.js index update
### Wallet

Iquidus Explorer is intended to be generic, so it can be used with any wallet following the usual standards. The wallet must be running with atleast the following flags

    -daemon -txindex
    
### Security

Ensure mongodb is not exposed to the outside world via your mongo config or a firewall to prevent outside tampering of the indexed chain data. 

### Known Issues

**script is already running.**

If you receive this message when launching the sync script either a) a sync is currently in progress, or b) a previous sync was killed before it completed. If you are certian a sync is not in progress remove the index.pid and db_index.pid from the tmp folder in the explorer root directory.

    rm tmp/index.pid
    rm tmp/db_index.pid

**exceeding stack size**

    RangeError: Maximum call stack size exceeded

Nodes default stack size may be too small to index addresses with many tx's. If you experience the above error while running sync.js the stack size needs to be increased.

To determine the default setting run

    node --v8-options | grep -B0 -A1 stack_size

To run sync.js with a larger stack size launch with

    node --stack-size=[SIZE] scripts/sync.js index update

Where [SIZE] is an integer higher than the default.

*note: SIZE will depend on which blockchain you are using, you may need to play around a bit to find an optimal setting*

### License

Copyright (c) 2015, Iquidus Technology  
Copyright (c) 2015, Luke Williams  
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

* Neither the name of Iquidus Technology nor the names of its
  contributors may be used to endorse or promote products derived from
  this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
