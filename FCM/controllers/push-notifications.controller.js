var admin = require('firebase-admin');
var fcm = require('fcm-notification');

var serviceAccount = require('../config/push-notification-key.json');
const { response } = require('express');
const certPath = admin.credential.cert(serviceAccount);
var FCM = new fcm(certPath);

var androidToken = 'dt42pPafQ-yJNu-5mwHkAT:APA91bG0sLFKZ5t1sRhkpATcHGXM4MI6U-k-A5Y6yvQxE_Xa6njq_CrjYWLOnqOllCnEpf0PzxyVy98e6Aoajmua-h2bDMksIkL-p1tdmD7r9tw02-ZeLyiGaQSHuxyDJpQDIGFWPxdd';
var iosToken = 'd64_Osyp5Uv1lduHtri09m:APA91bHgJOfdDcLlVuwjhNraXo50Lq7GN_uz8E3HcKBib5Y6HpOh2Yt8ECbJEP5P8jZHEoMGns3dhQKCt4rd02i-UfCfkcQsf-zTbuS0QUY5TB_l5Qp-V2xPVXQVUM_1e52mB9Uy8NkU';

var Tokens = [androidToken, iosToken];

exports.sendToSingleToken = (req, res, next) => {

    try {
        let message = {
            notification: {
                title: 'Test Notification',
                body: 'Notification Message'
            },
            // data: {
            //     orderId: '123456',
            //     orderDate: '2023-01-18'
            // },
            token: req.body.fcm_token,
        };

        FCM.send(message, function (err, resp) {
            if (err) {
                return res.status(500).send({
                    message: err
                });
            } else {
                return res.status(200).send({
                    message: "Notification sent"
                });
            }
        });



    } catch (err) {
        throw err;
    }


};

exports.sendToMultipleTokens = (req, res, next) => {

    try {
        let message = {
            notification: {
                title: 'Test Notification',
                body: 'Notification Message'
            },

        };

        FCM.sendToMultipleToken(message, Tokens, function (err, response) {
            if (err) {
                console.log('err--', err);

                return res.status(500).send({
                    message: err
                });
            } else {
                console.log('response-----', response);

                return res.status(200).send({
                    message: "Notification sent"
                });
            }

        });

    } catch (err) {
        throw err;
    }

};

