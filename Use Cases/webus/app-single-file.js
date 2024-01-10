const express = require('express');
const mongoose = require('mongoose');

require('./models/tickets')
require('./models/newsletter')
require('./models/schedules')
const Ticket = mongoose.model('tickets');
const Newsletter = mongoose.model('newsletter');
const Schedule = mongoose.model('schedules');

const app = express();
const router = express.Router();
app.use(express.json())

// connect to database
mongoose.connect("mongodb://localhost:27017/webus", { useUnifiedTopology: true, useNewUrlParser: true });

mongoose.connection.once('open', () => {
  console.log('MongoDB database connection established successfully');
});
mongoose.connection.on('error', (err) => {
  console.log(`🙅 🚫 🙅 🚫 🙅 🚫 🙅 🚫 → ${err.message}`, '[App]');
});


router.post('/buy_ticket', function (req, res) {
  console.log("lol");
  const { name, e_mail, credit_card, destination, schedule } = req.body;

  const ticket = {
    name: name,
    e_mail: e_mail,
    destination: destination,
    date: Date.parse(schedule),
    credit_card: credit_card,
  };

  Ticket.create(ticket, (err, createdTicket) => {
    if (err) { res.sendStatus(400); return }
    res.sendStatus(200);
  });
});

router.post('/subscribe', function (req, res) {
  const { e_mail } = req.body;

  if (!e_mail) {
    res.status(400).json('Missing information'); return;
  }

  /* Add new e-mail to database */
  const subscription = {
    e_mail: e_mail,
  };

  Newsletter.create(subscription, (err, subscribedEmail) => {
    if (err) { res.status(400).json('Error subscribing to newsletter.'); return; }

    Ticket.find({ $and: [{ e_mail: e_mail }, { date: { $gte: new Date(2020) } }] },
      (err, tickets) => {
        if (tickets.length >= 10) {
          console.log("Send Promo Code");
          res.status(200).json({ subscribedEmail, frequentTraveler: true });
        }
        else res.status(200).json({ subscribedEmail, frequentTraveler: false });
      })
  });
});

router.get('/schedules', function (req, res) {
  Schedule.find({}, (err, schedules) => {
    if (err) { res.status(400).json('Error fetching schedules.'); return; }
    res.status(200).json(schedules);
  });
});

router.get('/purchase_history', function (req, res) {
  const { name } = req.query;

  Ticket.find({ $where: "this.name === '" + name + "'" }, 'name destination date -_id', (err, tickets) => {
    if (err) { res.status(400).json('Error fetching ticket history.'); return; }
    res.status(200).json(tickets);
  })
})


app.use(router)

module.exports = app;
