
const express=require('express');
const User = require('../models/user');
const authRouter=express.Router();


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
            return res.status(400).json({message:"User with same email already exists"})
        }

        //post that data in databse
        let user=new User({
            email:email,
            name:name,
            password:password
        })

        user= await user.save();
        res.json(user);
        // return that data to user
    } catch (e) {
        res.status(500).json({error: e.message});
    }
    
})
module.exports= authRouter;