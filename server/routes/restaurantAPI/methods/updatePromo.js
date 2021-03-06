const pool = require('../../../db'); // psql db
const log = require('../../../logger');
const rsql = require('../../../sql/restaurant');

module.exports = (req, res) => {
    log.info('Querying update rPromo.');
    //const rid = req.params.rid;
    const pid = req.params.pid;
    const pdesc = req.body.description;
    const startDay = req.body.start_day;
    const endDay = req.body.end_day;

    pool.query(rsql.update.promo, [pid, pdesc, startDay, endDay],
        (qerr, qres) => {
            if (qerr) {
                console.log(qerr);
                res.status(500).send(qerr)
            } else {
                res.json(qres.rows)
            }
        })
};

