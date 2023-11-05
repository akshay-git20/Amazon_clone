//IMport From packages
const express=require('express');
const mongoose=require('mongoose'); 

//Import FROM OTHER FILES
const authRouter = require('./routes/auth');
const adminRouter = require('./routes/admin');
const productRouter = require('./routes/product');
const userRouter = require('./routes/user');

//INit
const app=express();
const PORT=3000;
const db="mongodb+srv://akshaypotkhule123:Akshay123@cluster0.8ml41eb.mongodb.net/?retryWrites=true&w=majority";




//connect to database
mongoose.connect(db).then(()=>{
    console.log("Connection Succesful");
})
.catch((e)=>{
    console.log(e);
})

//Middleware
app.use(express.json())
app.use(authRouter)
app.use(adminRouter)
app.use(productRouter)
app.use(userRouter)

//post request



// app.get('/hello-world',(req,res) =>{
//     res.json({name:"hello world"});
// })

// creating An API
app.listen(PORT,"192.168.0.137",() => {
    console.log(`connected at port ${PORT}`)
})
//localhost

