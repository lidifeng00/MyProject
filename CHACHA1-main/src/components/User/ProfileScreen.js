import React, { Component } from 'react';
import { Formik, Field, Form, ErrorMessage } from 'formik';
import * as Yup from 'yup';
import { reqUpdateProfile } from "../../api";

import {connect} from "react-redux";
import {fetchData} from "../../redux/actions";

import "./Profile.css"

const nameRegex = /^([A-Za-zÀ-ÿ][-,a-z. ']+[ ]*)+$/;
const phoneRegex = /^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$/;

class ProfileScreen extends Component {
  constructor(props) {
    super(props);
    this.state = {
      username: "",
      email: "",
      profile: {
        firstname: "",
        lastname: "",
        phone: "",
        address: "",
      }
    };
  }
  
  render() {
    const userData = this.props.user.userData;
    let profile = {
      firstname: '',
      lastname: '',
      phone: '',
      address: ''
    };
    if (userData && userData.profile) {
      profile = userData.profile;
    }
    return (
      <div id="profile-main">
        <h1>Profile</h1>
        <Formik
          enableReinitialize={true}
          initialValues={{
            username: userData.username,
            email: userData.email,
            firstname: profile.firstname,
            lastname: profile.lastname,
            phone: profile.phone,
            address: profile.address
          }}
          validationSchema={Yup.object({
            firstname: Yup.string().matches(nameRegex, 'Invalid first name'),
            lastname: Yup.string().matches(nameRegex, 'Invalid last name'),
            phone: Yup.string().matches(phoneRegex, 'Invalid phone number')
          })}
          onSubmit={(values, { setSubmitting }) => {
            const data = {
              profile: {
                firstname: values.firstname,
                lastname: values.lastname,
                phone: values.phone,
                address: values.address
              }
            }
            reqUpdateProfile(data)
              .then(response => {
                this.props.fetchData();
                setSubmitting(false);
              });
          }}
        >
          {({ isSubmitting }) => (
            <Form>
              <label className="profile-screen-label" htmlFor="username">User name</label>
              <Field className="profile-screen-input" type="text" name="username" disabled />
              <label className="profile-screen-label" htmlFor="email">Email</label>
              <Field className="profile-screen-input" type="email" name="email" disabled />
              <ErrorMessage className="profile-error" name="email" component="div" />
              <label className="profile-screen-label" htmlFor="firstname">First name</label>
              <Field className="profile-screen-input" type="text" name="firstname" />
              <ErrorMessage className="profile-error" name="firstname" component="div" />
              <label className="profile-screen-label" htmlFor="lastname">Last name</label>
              <Field className="profile-screen-input" type="text" name="lastname" />
              <ErrorMessage className="profile-error" name="lastname" component="div" />
              <label className="profile-screen-label" htmlFor="phone">Phone number</label>
              <Field className="profile-screen-input" type="text" name="phone" />
              <ErrorMessage className="profile-error" name="phone" component="div" />
              <label className="profile-screen-label" htmlFor="address">Address</label>
              <Field className="profile-screen-input" type="text" name="address" />
              <ErrorMessage className="profile-error" name="address" component="div" />
              <button type="submit" disabled={isSubmitting}>
                Update
              </button>

              </Form>
            )}
          </Formik>


      </div>

    );
  }
}

export default connect(
  state => ({user: state.fetchreducer}),
  {fetchData}
)(ProfileScreen);