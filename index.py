#-*-coding:utf-8 -*-

#sudo pip install python-redmine
#pip install DingtalkChatbot
#https://github.com/zhuifengshen/DingtalkChatbot

from pprint import pprint
from redminelib import Redmine
import urllib
import urllib2
import json
import sys
import socket
import datetime

reload(sys)
sys.setdefaultencoding('utf8')


#发送钉钉消息
def sendDingDingMessage(url, data):
    req = urllib2.Request(url)
    req.add_header("Content-Type", "application/json; charset=utf-8")
    opener = urllib2.build_opener(urllib2.HTTPCookieProcessor())
    response = opener.open(req, json.dumps(data))
    return response.read()

def main():
	redmine = Redmine('http://qqbibi.net:30002', version='3.3.6', key='3e6047a416e66bbe85c81c6c5c502697b216b9d4')

	qqbibi = redmine.project.get('qqbibi')

	print '项目名称:',qqbibi.name


	yesterday = datetime.date.today() - datetime.timedelta(days=1)

	vers = redmine.version.filter(project_id = 'qqbibi', subproject_id='*')
	# pprint (vars(vers))

	# print list(vers.keys())

	verlist = []
	for v in vers:
		#print v.id, v
		verlist.append(v.name)

	# print verlist

	#print ','.join(verlist)


	issues = redmine.issue.filter(
			project_id = qqbibi.id,
			subproject_id = '*',
			status_id = 2,
			due_date = '<=%s' % yesterday.strftime("%Y-%m-%d"),
			# fixed_version_id = 40, #','.join(verlist),
			sort = 'assigned_to: asc'
		)

	# pprint (vars(issues[0]))

	mobile = []
	delaymission = '【过期的任务】\n'
	lastuser = ''
	for issue in issues:
		if (not hasattr(issue, 'fixed_version')) or (issue.fixed_version.name == '非计划内'):
			continue;

		if (lastuser != issue.assigned_to.name.replace(' ', '')):
			delaymission = delaymission + '-'*60 +'\n'

		delaymission = delaymission + '#%-5s %s %s (%s)\n'%(issue.id, issue, issue.fixed_version.name if hasattr(issue, 'fixed_version') else '', issue.assigned_to.name.replace(' ', '')) 

		mobile.append(redmine.user.get(issue.assigned_to.id).login)

		lastuser = issue.assigned_to.name.replace(' ', '')

	print delaymission

	#发送钉钉机器人
	posturl = "https://oapi.dingtalk.com/robot/send?access_token=7f6b35d862665c477fb96f3715ec0a40d83eaa725000a38fedc00173e88b596a"
	data = {
			"msgtype": "text", 
			"text": {
					"content": delaymission
				}, 
				"at":{
					"atMobiles": mobile,
					"isAtAll": "false"
				}
	 		}
	#sendDingDingMessage(posturl, data)


if __name__ == '__main__':
	main()
