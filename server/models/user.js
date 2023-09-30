
const mongoose = require('mongoose');

const userSchema=mongoose.Schema({
    name:{
        type:String,
        required:true,
        trim:true,
        maxlength:32
    },
    email:{
        type:String,
        required:true,
        trim:true,
        validate:{
            validator: (value)=>{
                const re =/^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
                return value.match(re);
            },
            message: "Please enter a valid email"
        }
    },
    password:{
        type:String,
        required:true,
        trim:true,
        validate:{
            validator: (value)=>{
                return value.length > 6;
            },
            message: "Please enter long Password"
        }
    },
    address:{
        type:String,
        default:'',
        trim:true,
    },
    type:{
        type:String,
        default:'user',
        trim:true,
    },

})

const User=mongoose.model("User",userSchema);
module.exports=User;