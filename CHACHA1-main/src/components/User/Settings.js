import React from 'react';
import {ErrorMessage, Field, Form, Formik} from "formik";
import * as Yup from "yup";
import { reqUpdatePassword} from "../../api";
import "./Profile.css"
import BootstrapSwitchButton from "bootstrap-switch-button-react";
import swal from 'sweetalert';
import responsiveObserve from 'antd/lib/_util/responsiveObserve';

const passwordReg = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[^]{6,12}$/;

class Settings extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            oldPassword: '',
            newPassword: '',
            conPassword: '',
        };
    }
  render() {
    return (
      <div>
        <h1>Settings</h1>
        <hr/>
          <div id="profile-wrapper">
              <div id="profile-main">
                  <h4>Change Password</h4>
                  <Formik
                      enableReinitialize={true}
                      initialValues={{
                          oldPassword: this.state.oldPassword,
                          newPassword: this.state.newPassword,
                          conPassword: this.state.conPassword
                      }}
                      validate={values => {
                          let errors = {};
                          if((values.newPassword.length >12 || values.newPassword.length<6) && values.newPassword !== ''){
                              errors.newPassword = 'Password should be 6-12 characters '
                          }
                          if(values.newPassword !== values.conPassword ){
                              errors.conPassword = 'The two passwords are inconsistent'
                          }
                          return errors;
                      }}
                      validationSchema={Yup.object({
                          oldPassword: Yup.string().matches(passwordReg, 'Invalid Password'),
                          newPassword: Yup.string().matches(passwordReg, 'Invalid Password'),
                          conPassword: Yup.string().matches(passwordReg, 'Invalid Password')
                      })}
                      onSubmit={async (values, {setSubmitting}) => {
                          const data = {
                              newPassword: values.newPassword,
                              oldPassword: values.oldPassword
                          };
                          const response = await reqUpdatePassword(data);
                          const result =response.data
                          if (result.code === 0) {
                            swal ({title:result.msg, icon: "success"})
                          }
                          else {
                            swal ({title:result.msg, icon: "error"})
                          }
                      }}
                  >
                      {({ isSubmitting }) => (
                          <Form>
                              <label  className="profile-screen-label" htmlFor="oldPassword">Old Password</label>
                              <Field className="profile-screen-input" type="password" name="oldPassword"/>
                              <ErrorMessage className="profile-error" name="oldPassword" component="div" />
                              <label  className="profile-screen-label" htmlFor="newPassword">New Password</label>
                              <Field className="profile-screen-input" type="password" name="newPassword" />
                              <ErrorMessage className="profile-error" name="newPassword" component="div" />
                              <label  className="profile-screen-label" htmlFor="conPassword">Confirm Password</label>
                              <Field className="profile-screen-input" type="password" name="conPassword" />
                              <ErrorMessage className="profile-error" name="conPassword" component="div" />
                              <button type="submit" disabled={isSubmitting}>
                                  Update
                              </button>
                          </Form>
                      )}
                  </Formik>
              </div>
              <hr/>
              <div className='life-style'>
                  <h4>Lifestyle & Notification Preferences</h4>
                    <br/>
                  <div className='life-style-content'>
                      <div className='life-style-content-signin'>
                          <p>
                              Sign up to get special deals, exclusive CHA-CHA content and offers via email.
                          </p>
                          <div className='life-style-content-signin-switch'><BootstrapSwitchButton checked={true} onstyle="dark" /></div>
                      </div>

                      <div className='life-style-content-signin'>
                          <p >
                              Sign up to get special deals, exclusive CHA-CHA content and offers via text.
                          </p>
                          <div className='life-style-content-signin-switch'><BootstrapSwitchButton checked={true} onstyle="dark" /></div>
                      </div>
                      <br/>
                      <p>By signing up for text alert I agree to receive
                      recurring automated promotional and personalized marketing
                      text messages from CHA-CHA</p>
                  </div>
              </div>
          </div>
      </div>
    );
  }
}

export default Settings;