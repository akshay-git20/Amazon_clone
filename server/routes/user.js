const express = require('express');
const userRouter = express.Router();
const {Product}=require('../models/product');
const auth = require('../middlewares/auth');
const User=require('../models/user');
const Order = require('../models/order');

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

// save user address
userRouter.post("/api/save-user-adddress",auth, async(req,res)=>{
    try {
        const {address} = req.body
        let user = await User.findById(req.user)
        user.address = address
        user = await user.save()
        res.json(user);
    } catch (err) {
        res.status(500).json({error:err.message})
    }
})

//order product
userRouter.post("/api/order", auth, async (req, res) => {
    try {
      const { cart, totalPrice, address } = req.body;
      let products = [];
  
      for (let i = 0; i < cart.length; i++) {
        let product = await Product.findById(cart[i].product._id);
        if (product.quantity >= cart[i].quantity) {
          product.quantity -= cart[i].quantity;
          products.push({ product, quantity: cart[i].quantity });
          await product.save();
        } else {
          return res
            .status(400)
            .json({ msg: `${product.name} is out of stock!` });
        }
      }
  
      let user = await User.findById(req.user);
      user.cart = [];
      user = await user.save();
  
      let order = new Order({
        products,
        totalPrice,
        address,
        userId: req.user,
        orderedAt: new Date().getTime(),
      });
      order = await order.save();
      res.json(order);
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  });

module.exports = userRouter;