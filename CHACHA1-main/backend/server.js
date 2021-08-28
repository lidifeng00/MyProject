require("dotenv").config();

const express = require('express')
const app = express()
const port = 5000
const expJWT = require ('express-jwt')
const bodyParser = require('body-parser');
const routes = require('./userroutes');

const mongoose = require('mongoose');



mongoose.connect('mongodb+srv://lidifeng00:q690519126@cluster0.pn5i0.mongodb.net/test', { useNewUrlParser: true, useUnifiedTopology: true ,useCreateIndex: true});

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

//express token
app.use(expJWT({secret:process.env.JWT_KEY, algorithms: ['HS256']}).unless({path: ['/signin', '/signup']}));

//err information
app.use((err, req, res, next) =>{
    if(err.name === 'UnauthorizedError'){
        return res.send({
            status: 1,
            msg: 'TOKEN ERROR'
        })
    }
})

//cors
app.use(function(req, res, next) {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
    res.header("Access-Control-Allow-Methods", "GET, POST, OPTIONS, PUT, DELETE");
    next();
});



routes(app);


app.listen(port, () => {
    console.log(`Example app listening at http://localhost:${port}`)
})
