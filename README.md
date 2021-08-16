# YDBTube

YDBTube is a proof of concept app that downloads and saves youtube videos for offline use. it uses the library ytdl to download youtube videos

## Manual Setup for Development
The GUI is compromised of two parts. 
 1. **The backend**: written in M
 2. **The fontend**: written in VueJs on top of the UI framework [Quasar](https://quasar.dev/)

### Development dependencies (Nodejs and npm are only used in development)
**Node.js** and **npm** (to compile javascript files)
```bash
sudo apt update
sudo apt install nodejs npm
sudo npm install -g ytdl
```


#### Running the app in development mode
- Git clone the project in any working directory. 
```bash
git clone https://gitlab.com/ahmedydb/ydbtube.git
```

- Change dirctory
```bash
cd YDBTube
```

##### Server
- Point your ydb_routines environment  to the routines folder
```bash
export ydb_routines="$PWD/routines"
```
- Start the integrated web server. 
By default the web server listens on port 8090. This can be changed by passing the ```Start``` label a port number, and modifying the proxy section of ```quasar.conf.js``` file 
```bash
$ydb_dist/yottadb -run Start^YDBTUBE
```

##### Client
- Download the nodejs dev dependencies.
```bash 
npm install
```
- Run the front-end development server
```bash
npm run dev
```
- Navigate to http://localhost:8080. If port 8080 is unavailable, ```quasar``` will use the closest available port.  

#### Running the app in production mode.
- Make sure you build the application
 ```bash
 npm run build
 ```
- Start the web server using default port (8090)
```bash
$ydb_dist/yottadb -run Start^YDBTUBE
```

- Point your browser to the running application
```bash
http://localhost:8090
```