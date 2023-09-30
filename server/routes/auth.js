
const express=require('express');
const User = require('../models/user');
const authRouter=express.Router();
const bcrypt = require('bcryptjs');


// authRouter.get("/user",(req,res)=>{
//     res.json({name:"akshay"})
// })

//post request
authRouter.post('/api/signup',async(req,res)=>{
    try {
        //get the data from the client
        const{'name':name,'email':email,'password':password}=req.body;


        const existingUser= await User.findOne({email:email})
        if(existingUser){
            return res.status(400).json({msg:"User with same email already exists"})
        }

        //post that data in databse
        //hash the password
        var salt = bcrypt.genSaltSync(10);
        var hashpass = bcrypt.hashSync(password, salt);

        let user=new User({
            email:email,
            name:name,
            password:hashpass
        })

        user= await user.save();

        // return that data to user
        res.json(user);
        
    } catch (e) {
        res.status(500).json({error: e.message});
    }
    
})

//Sign In Route

module.exports= authRouter;