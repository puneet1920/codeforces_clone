// libraries
const express = require('express');
const rightPanelUtils = require('../../utils/rightPanel-utils');

const DB_users = require(process.env.ROOT + '/DB-codes/DB-users-api');
const DB_contest = require(process.env.ROOT + '/DB-codes/DB-contest-api');

const timeUtils = require(process.env.ROOT + '/utils/time-utils');
const contestUtils = require(process.env.ROOT + '/utils/contest-utils');

const contestRouter = require('./contestEntry/contestEntry.js');

const router = express.Router({mergeParams : true});
router.get('/', async (req, res) =>{


    let contestsMap = {}

    let contestsFuture = await DB_contest.getFutureContests();
    contestsFuture.forEach(contest =>{
        contestsMap[contest.ID] = contest;
        contest.ADMINS = [];
        contest.TIME_LEFT = timeUtils.timeAgo(contest.TIME_START);
    });

    let contestsPast = await DB_contest.getPastContests();
    contestsPast.forEach(contest =>{
        contestsMap[contest.ID] = contest;
        contest.ADMINS = [];
        contest.TIME_AGO = timeUtils.timeAgo(contest.TIME_START);
    });

    let contestAdminsList = await DB_contest.getAllContestAdmins();

    contestAdminsList.forEach(x => {
        contestsMap[x.CONTEST_ID].ADMINS.push(x);
    })

    let rightPanel = await rightPanelUtils.getRightPanel(req.user);

    res.render('layout.ejs', {
        title: `Contests - ForceCodes`,
        body: ['panel-view', 'contestAll'],
        user: req.user,
        contestsFuture: contestsFuture,
        contestsPast : contestsPast,
        rightPanel : rightPanel
    });   
});

router.get('/new', async(req, res) =>{
    if(req.user == null || !req.user.isAdmin){
        res.redirect('/contest');
    }
    else{
        let users = await DB_users.getUserInfoByHandles([req.user.handle]);
        users[0].AUTHOR = 'true';

        let rightPanel = await rightPanelUtils.getRightPanel(req.user);

        res.render('layout.ejs', {
            title : 'New Contest - ForceCodes',
            body : ['panel-view', 'contestForm'],
            user : req.user,
            postURL : 'contest/new',
            admins : users,
            errors : [],
            rightPanel : rightPanel
        });
    }
})

router.post('/new', async(req, res) =>{
    if(req.user == null || !req.user.isAdmin){
        res.redirect('/contest');
    }
    else{
        let errors = [];
        let contest = {};

        await contestUtils.processContest(req.body, contest, errors, null);
        contest.mainAdmin = req.user.handle;

        if(errors.length == 0){
            let contestId = await DB_contest.createContest(contest);
            if(contestId == null)
                errors.push('Contest title is already used');
            else
                res.redirect('/contest');
        }

        if(errors.length > 0){
            let users = await DB_users.getUserInfoByHandles(contest.admins);
            for(let i = 0; i<users.length; i++){
                    users[i].AUTHOR = 'false';
            }
            //TODO assign better logic
            users.splice(0, 0, {HANDLE : req.user.handle, COLOR: 'black', AUTHOR : 'true'});

            let rightPanel = await rightPanelUtils.getRightPanel(req.user);

            res.render('layout.ejs', {
                title : 'New Contest - ForceCodes',
                body : ['panel-view', 'contestForm'],
                user : req.user,
                postURL : 'contest/new',
                admins : users,
                errors : errors,
                form : {
                    title : req.body.title,
                    start : req.body.start,
                    duration : req.body.duration,
                    min_rating : req.body.min_rating,
                    max_rating : req.body.max_rating,
                },
                rightPanel : rightPanel
            });
        }
    }
})

router.use('/:contestId', contestRouter);

module.exports = router;