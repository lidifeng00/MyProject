import ajax from "./ajax";

export const reqLogin =(user) => ajax('/signin', user, 'POST')
export const reqRegister =(user) =>ajax('/signup',user,'POST')
export const reqUpdateProfile =(user) =>ajax('/updateprofile',user,'POST')
export const reqProfile =(user) =>ajax('/profile',user,'GET')

export const reqUpdatePassword =(user) =>ajax('/user/settings',user,'POST')
export const reqGetMembership =(user) => ajax('/user/member',user,'POST')

export const reqUserData =(user) =>ajax('/userdata',user,'GET')
export const reqUpdateFavorite =(user) =>ajax('/user/favorites',user,'POST')

export const reqAddOrder =(user) => ajax('/addorder', user, 'POST')
export const reqGetCoupon =(user) => ajax('/user/coupon', user, 'POST')