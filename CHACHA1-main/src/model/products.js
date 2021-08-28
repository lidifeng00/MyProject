// TODO: Move this data into the backend DB
const productInfoMap = {
  bubbleTea: {
    title: 'Bubble Tea',
    type: 'milkTea',
    imgFileName: 'bubble.webp',
    price: '$4.49 - $4.99'
  },
  taroTea: {
    title: 'Taro Milk Tea',
    type: 'milkTea',
    imgFileName: 'taro.webp',
    price: 'TBD'
  },
  cheeseTea: {
    title: 'Cheese Foam Tea',
    type: 'milkTea',
    imgFileName: 'cheese.webp',
    price: 'TBD'
  },
  mangoTea: {
    title: 'Mango Iced Tea',
    type: 'fruitTea',
    imgFileName: 'mangoTea.jpg',
    price: 'TBD'
  },
  berryTea: {
    title: 'Mix Berry Tea',
    type: 'fruitTea',
    imgFileName: 'berry.jpg',
    price: 'TBD'
  },
  passionFruitTea: {
    title: 'Passion Fruit QQ',
    type: 'fruitTea',
    imgFileName: 'passion.jpeg',
    price: 'TBD'
  },
  matchaTea: {
    title: 'Matcha Latte',
    type: 'specialtyDrinks',
    imgFileName: 'matcha.jpg',
    price: 'TBD'
  },
  thaiTea: {
    title: 'Thai Tea',
    type: 'specialtyDrinks',
    imgFileName: 'thai.jpg',
    price: 'TBD'
  },
  peachOolong: {
    title: 'Peach Oolong',
    type: 'specialtyDrinks',
    imgFileName: 'brew.jpg',
    price: 'TBD'
  }
};

module.exports = {
  getProductInfo: function(productId) {
    return productInfoMap[productId];
  }
};