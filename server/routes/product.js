const express = require("express");
const productRouter = express.Router();
const auth = require("../middlewares/auth");
const Product = require("../models/product");

//get  the products for category
productRouter.get("/api/products", auth, async (req, res) => {
  try {
    const products = await Product.find({ category: req.query.category });
    res.json(products);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// create a get request to seach products and get them
productRouter.get("/api/products/search/:name", async (req, res) => {
  try {
    const products = await Product.find({
      name: { $regex: req.params.name, $options: "i" },
    });
    res.json(products);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// create a post request route to rate the product
productRouter.post("/api/rate-product", auth, async (req, res) => {
  try {
    const { id, rating } = req.body;

    const ratingSchema = {
      userId: req.user,
      rating,
    };

    let product = await Product.findById(id);

    for (let i = 0; i < product.ratings.length; i++) {
      if (product.ratings[i].userId == req.user) {
        product.ratings.splice(i, 1);
        break;
      }
    }

    product.ratings.push(ratingSchema);
    product = await product.save();
    res.json(product);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

//create a getter for the deal of the day and the deal of the day is that deal which get a maximum rating
productRouter.get('/api/deal-of-day',auth, async(req,res) => {
    try {
       let products = await Product.find({}); 

       products = products.sort((a,b) => {

            let totalRatingsa=0;
            let totalRatingsb=0;

            for(let i=0;i<a.ratings.length;i++){
                totalRatingsa+=a.ratings[i].rating;
            } 

            for(let i=0;i<b.ratings.length;i++){
                totalRatingsa+=b.ratings[i].rating;
            }

            return totalRatingsb- totalRatingsa;
       })

       res.json(products[0]);
    } catch (err) {
        res.status(500).json({error:err.message});
    }
})

module.exports = productRouter;

