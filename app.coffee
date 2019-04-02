fs = require 'fs'
markdown = require 'markdown'
markdown = markdown.markdown
jade = require 'jade'

# 博文目录信息
blogdata = require './blogdata'

date = new Date()
date = date.toLocaleDateString()
date = date.replace /\-/g,'.'

catagolue = fs.readdirSync './draft'

# 读取markdown草稿文件中的内容，编译拼接成可以最后的html文件
gethtml = (name)->
    if name is '.DS_Store'
        return
    content = fs.readFileSync "./draft/#{name}",'utf-8'
    blogcontent = markdown.toHTML content

    # 解析文件名，分出类别
    names = name.split '.'
    namearray = names[0].split '~'
    type = namearray[0]
    name = namearray[1]

    # 添加进博文目录中
    blogdata["#{type}"].push({
        'title' : name,
        'time' : date,
        'url' : "/blog/"+name+".html"
        });

    # 生成html
    renderdata = {
        'blogcontent' : blogcontent,
        'catagolue' : blogdata,
        'title' : name
    }
    html = jade.renderFile './blog/model/singleblog.jade',renderdata
    fs.writeFileSync "./blog/#{name}.html",html,'utf-8'

    console.log name+' success!\n'

# 获取开始博客的目录
# 根据时间排序
getblogcata = (object) ->
    timeline = []
    blogcata = {}
    for k, v of object
        for o in v
            timeline.push o

    timeline.sort (a,b) ->
        at = new Date a.time
        at = at.getTime()
        bt = new Date b.time
        bt = bt.getTime()
        return bt-at

    for i in timeline
        time = new Date(i.time)
        # 时间规范化
        date = time.toLocaleDateString()
        dates = date.split('-')
        head = dates[0]+'年'+dates[1]+'月'
        if blogcata[head] is undefined
            blogcata[head] = [i]
        else
            blogcata[head].push i

    return blogcata

# retype = (object) ->
#     container = {}
#     for k, v of object
#         if (k is '编程思想') or (k is '算法')
#             if container['2'] is undefined
#                 container['2'] = v
#             else
#                 container['2'] = container['2'].concat v
#         else if (k is 'HTML') or (k is 'CSS') or (k is 'Javascript') or (k is '数据库') or (k is '后端开发') or (k is 'Web安全')
#             if container['3'] is undefined
#                 container['3'] = v
#             else
#                 container['3'] = container['3'].concat v
#         else if k is 'CTF'
#             container['6'] = v
#         else if k is '电脑技能'
#             container['4'] = v
#     return container

# 所有草稿执行
carry = () ->
    # blogdata = retype(blogdata)
    for cata in catagolue
        gethtml cata

    for k, v of blogdata
        v.sort (a,b) ->
            at = new Date a.time
            at = at.getTime()
            bt = new Date b.time
            bt = bt.getTime()
            return bt-at

    timedata = getblogcata blogdata
    store = JSON.stringify blogdata
    fs.writeFileSync './blogdata.json',store,'utf-8'

    # 生成博文主页
    renderdata = {
        'timeline' : timedata,
        'catagolue' : blogdata,
    }
    blogstart = jade.renderFile './blog/model/start.jade',renderdata
    fs.writeFileSync './blog/blog.html',blogstart,'utf-8'

    console.log 'main success!\n'
    console.log 'done!\n'

module.export = {
    'carry' : carry()
}
