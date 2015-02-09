SELECT COUNT(*), strftime('%Y-%m', date) AS month FROM okfn_mail GROUP BY strftime('%Y-%m', date) ORDER BY strftime('%Y-%m', date) DESC;

SELECT COUNT(*), strftime('%Y', date) AS month FROM okfn_mail GROUP BY strftime('%Y', date) ORDER BY strftime('%Y', date) DESC;

SELECT COUNT(DISTINCT(m.message_id)) AS total_messages, m.[from] FROM okfn_mail m GROUP BY m.[from] ORDER BY COUNT(DISTINCT(m.message_id)) DESC LIMIT 10;

SELECT COUNT(*), list FROM okfn_mail WHERE local_group = 0 AND strftime('%Y', date) = '2015' GROUP BY list ORDER BY COUNT(*) DESC;

SELECT COUNT(*), strftime('%Y-%m', date) AS month FROM okfn_mail WHERE strftime('%Y', date) = '2014' AND list = 'okfn-discuss'  GROUP BY strftime('%Y-%m', date) ORDER BY strftime('%Y-%m', date) DESC;

SELECT COUNT(*), subject AS month FROM okfn_mail WHERE strftime('%Y', date) = '2014' AND list = 'okfn-discuss'  GROUP BY subject ORDER BY COUNT(*) DESC LIMIT 10;


ALTER TABLE okfn_mail ADD COLUMN local_group TINYINT;
UPDATE okfn_mail SET local_group = 0;

UPDATE okfn_mail SET local_group = 1 WHERE list IN ('okfn-br',
'okfn-sp',
'okfn-de',
'irail',
'okfn-cz',
'okfn-ca',
'okfn-at',
'okfn-fr',
'okfn-it',
'okfn-be',
'okfn-au',
'okfn-za',
'okfn-dk',
'science-at',
'okfn-ar',
'open-science-de',
'okfn-en',
'okfn-in',
'okfn-bg',
'okfn-ch',
'codeforleipzig',
'okfn-se',
'codeformunich',
'codeforberlin',
'okfn-irl',
'okfn-bf',
'codeforde-cert',
'ckan-pt',
'okfn-no',
'okfn-hu',
'okfn-nl',
'codeforchemnitz',
'codeforde',
'open-data-nahverkehr',
'open-science-it',
'ok-berlin',
'codeforhamburg',
'ris',
'okfn-np',
'gastosabertos-dev',
'openglam-at',
'okfn-ro',
'okfn-fi',
'ddj-de-tools',
'okfn-ru',
'okfn-gr',
'offenes-parlament',
'codeforgiessen',
'okfn-py',
'okfn-sn',
'okfn-ma',
'okfn-bd',
'okfn-mena',
'okfn-ir',
'codingdavinci',
'smartcitizen',
'data-edu-au',
'okfn-uy',
'okfn-is',
'open-science-fi',
'openglam-de',
'okfn-tw',
'codeforkarlsruhe',
'open-aid-de',
'okfn-ec',
'okfn-cn',
'okfn-dz',
'froide-dev',
'oparl-tech',
'members-fi',
'ogd-fr',
'okfn-us',
'oppilaitosverkosto-fi',
'okf-fi',
'avoin-glam-fi',
'codeforstuttgart',
'okfn-jp',
'okfn-lt');

SELECT COUNT(*), local_group FROM okfn_mail GROUP BY list ORDER BY COUNT(*) DESC;

SELECT COUNT(*), strftime('%Y', date) AS month FROM okfn_mail WHERE local_group = 1 GROUP BY strftime('%Y', date) ORDER BY strftime('%Y', date) DESC;

.header on
.mode csv
    

SELECT
    strftime('%Y-%m', m.date) AS month,
    COUNT(DISTINCT(m.message_id)) AS total_messages,
    (SELECT COUNT(DISTINCT(lm.message_id)) FROM okfn_mail lm WHERE lm.local_group = 1 AND strftime('%Y-%m', m.date) = strftime('%Y-%m', lm.date)) AS local_messages,
    (SELECT COUNT(DISTINCT(lm.message_id)) FROM okfn_mail lm WHERE lm.local_group = 0 AND strftime('%Y-%m', m.date) = strftime('%Y-%m', lm.date)) AS global_messages
    FROM okfn_mail AS m
    WHERE
        strftime('%Y-%m', m.date) > '2010-12'
        AND strftime('%Y-%m', m.date) <= strftime('%Y-%m')
        AND m.list NOT IN ('ckan-dev', 'ckan-discuss')
    GROUP BY strftime('%Y-%m', m.date)
    ORDER BY strftime('%Y-%m', m.date) DESC;
