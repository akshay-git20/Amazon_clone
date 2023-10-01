const express = require("express");
const User = require("../models/user");
const authRouter = express.Router();
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const auth = require("../middlewares/auth");

// authRouter.get("/user",(req,res)=>{
//     res.json({name:"akshay"})
// })

//post request
authRouter.post("/api/signup", async (req, res) => {
  try {
    //get the data from the client
    const { name: name, email: email, password: password } = req.body;

    const existingUser = await User.findOne({ email: email });
    if (existingUser) {
      return res
        .status(400)
        .json({ msg: "User with same email already exists" });
    }

    //post that data in databse
    //hash the password
    var salt = bcrypt.genSaltSync(10);
    var hashpass = bcrypt.hashSync(password, salt);

    let user = new User({
      email: email,
      name: name,
      password: hashpass,
    });

    user = await user.save();

    // return that data to user
    res.json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

//Sign In Route
authRouter.post("/api/signin", async (req, res) => {
  try {
    const { email: email, password: password } = req.body;

    // finding user in database.
    const user = await User.findOne({ email });

    if (!user) {
      return res
        .status(400)
        .json({ msg: "User with this email does not exist" });
    }

    //compare passowrd
    const isMatch = await bcrypt.compareSync(password, user.password);

    if (!isMatch) {
      return res.status(400).json({ msg: "Incorrect Password" });
    }

    const token = jwt.sign({ id: user._id }, "passwordKey");

    res.json({ token, ...user._doc });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

authRouter.post("/tokenIsValid", async (req, res) => {
  try {

    const token = req.header("x-auth-token");
    if (!token) return res.json(false);

    const verified = jwt.verify(token, "passwordKey");
    if (!verified) return res.json(false);

    const user = await User.findById(verified.id);
    if (!user) return res.json(false);

    return res.json(true);

  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});


authRouter.get('/',auth, async(req,res) =>{
  const user= await User.findById(req.user);
  return res.json({...user._doc,token:req.token});
})

module.exports = authRouter;
