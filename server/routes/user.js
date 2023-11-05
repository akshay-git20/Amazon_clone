const express = require('express');
const userRouter = express.Router();
const {Product}=require('../models/product');
const auth = require('../middlewares/auth');
const User=require('../models/user');

//add product to cart
userRouter.post("/api/add-to-cart",auth,async (req,res) =>{
    try {
        const {id}= req.body
        const product=await Product.findById(id);
        let user= await User.findById(req.user);

        if(user.cart.length == 0){
            user.cart.push({product,quantity:1});
        }else{
            const existingProduct = user.cart.find((ele) => ele.product._id.equals(product.id));
            if(existingProduct){
                existingProduct.quantity += 1;
            }else{
                user.cart.push({product,quantity:1});
            }
        }

        user=await user.save();
        res.json(user);
    } catch (err) {
        res.status(500).json({error:err.message})
    }
})

userRouter.delete("/api/remove-from-cart/:id",auth,async (req,res) =>{
    try {
        const product=await Product.findById(req.params.id);
        let user= await User.findById(req.user);

        
        const existingProduct = user.cart.find((ele) => ele.product._id.equals(product.id));
        if(existingProduct.quantity>1){
                existingProduct.quantity -= 1;
         }else{
                const index = user.cart.indexOf(existingProduct);
                user.cart.slice(index,1);
        }
        

        user=await user.save();
        res.json(user);
    } catch (err) {
        res.status(500).json({error:err.message})
    }
})

module.exports = userRouter;