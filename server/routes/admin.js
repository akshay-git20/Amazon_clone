const express= require('express');
const adminRouter=express.Router();
const Product=require('../models/product');
const admin=require('../middlewares/admin');


//add product
adminRouter.post("/admin/add-product",admin,async (req,res) =>{
    try {
        const {name,price,description,category,quantity,images}=req.body;
        let product = new Product({
            name,
            price,
            description,
            category,
            quantity,
            images
        })

        product = await product.save();

        res.json(product);

    } catch (err) {
        res.status(500).json({error:err.message})
    }
})

module.exports=adminRouter;