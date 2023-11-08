const express= require('express');
const adminRouter=express.Router();
const {Product}=require('../models/product');
const admin=require('../middlewares/admin');
const Order = require('../models/order');



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
            images,
        })

        product = await product.save();

        res.json(product);

    } catch (err) {
        res.status(500).json({error:err.message})
    }
})

//get all the products
adminRouter.get('/admin/get-products',admin,async (req,res) => {
    try {
       const products = await Product.find({});
        res.json(products);
    }catch (err) {
        res.status(500).json({error:err.message})
    }
} )

//delete the product
adminRouter.delete('/admin/delete-product' , admin,async(req,res) =>{
    try {
        const {id}= req.body;
        const product = await Product.findByIdAndDelete(id);
        res.json(product);
    } catch (err) {
        res.status(500).json({error:err.message})
    }
})

//get all the orders
adminRouter.get('/admin/get-orders',admin,async (req,res) => {
    try {
       const orders = await Order.find({});
        res.json(orders);
    }catch (err) {
        res.status(500).json({error:err.message})
    }
} )

// change the order status
adminRouter.post('/admin/change-order-status' , admin,async(req,res) =>{
    try {
        const {id,status}= req.body;
        let order = await Order.findById(id);
        order.status=status;
        order = await order.save();
        res.json(order);
    } catch (err) {
        res.status(500).json({error:err.message})
    }
})

// get total earnings and cateogry wise earnings.
adminRouter.get('/admin/analytics' , admin,async(req,res) =>{
    try {

        //category wise earnigs fetching
        let mobilesEarnings = await fetchCategoryWiseEarnings("Mobiles");
        let essentialsEarnings = await fetchCategoryWiseEarnings("Essentials");
        let appliancesEarnings = await fetchCategoryWiseEarnings("Appliances");
        let booksEarnings = await fetchCategoryWiseEarnings("Books");
        let fashionEarnings = await fetchCategoryWiseEarnings("Fashion");

        let totalEarnings = mobilesEarnings+essentialsEarnings+appliancesEarnings+booksEarnings+fashionEarnings;

        let earnigs={
            totalEarnings,
            mobilesEarnings,
            essentialsEarnings,
            appliancesEarnings,
            booksEarnings,
            fashionEarnings
        }
        res.json(earnigs);
    } catch (err) {
        res.status(500).json({error:err.message})
    }
})


async function fetchCategoryWiseEarnings(category){
    let orders = await Order.find({}); 
    let earnings=0; 

    for(let i=0; i< orders.length;i++){
        for(let j=0;j<orders[i].products.length;j++){
            if(orders[i].products[j].product['category'] == category){
                earnings+=orders[i].products[j].product['price']*orders[i].products[j].quantity;
            }
        }
    }

    return earnings;
}

module.exports=adminRouter;