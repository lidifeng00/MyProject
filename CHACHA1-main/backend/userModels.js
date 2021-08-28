const mongoose = require('mongoose');


module.exports = mongoose.model('project-register', {
  email: { type: String, unique: true, default: '', required: true },
  password: { type: String, default: '', required: true },
  username: { type: String, unique: true, default: '', required: true },
  isadmin: { type: Boolean, default: false, required: true },
  firstmember: {type:Boolean,default:true, required:true},
  memberdate: {type:String, default:' ',required:true},
  membercoupon: {type:Boolean, default:false,required:true},
  profile: {
    firstname: { type: String, default: '' },
    lastname: { type: String, default: '' },
    phone: { type: String, default: '' },
    address: { type: String, default: '' }
  },
  favorites: { type: [String] },
  nextid: { type: Number, default: 0 },
  orders: [{
    orderId: { type: String, required: true },
    timemillis: { type: Number, required: true },
    subtotal: { type: Number, required: true },
    discount: { type: Number, required: true },
    totalPrice: { type: Number, required: true },
    pickUp: { type: Boolean, required: true },
    location: { type: String, required: true },
    usedCoupon: { type: Number, required: true },
    products: [{
      name: { type: String, required: true },
      size: { type: String, default: '' },
      ice: { type: String, default: '' },
      unitPrice: { type: Number, required: true },
      price: { type: Number, required: true },
      sweetness: { type: String, default: '' },
      extras: { type: [String] },
      quantity: { type: Number, required: true }
    }]
  }],
  nextCouponid: { type: Number, default: 0 },
  coupon: [{
    couponId: { type: String, required: true },
    couponType: {type: Number, required: true},
  }]
});
