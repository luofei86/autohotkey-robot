# autohotkey-robot

部署：

	将autohotkey-robot.rar复制到远程服务器上，在运行目录下解压文件，将文件中的vcode.rar在当前目录解压。配置相关app.conf中的参数，执行。建议早期执行时，可人工先进行观测，查看相关配置是否正常设置。


部署时注意事项：

1、执行环境WIN7 64位 IE7/8,检测当前环境是否支持当前程序，由于有些vps的系统有一定程序的裁剪，不太支持本程序运行。检测方式如下：

	1）打开IE，访问iqiyi网站， 在页面打开一个链接，这样当前存在两个IE页面。

	2）执行程序中的IELoop.exe,如果程序能正常弹出当前两个IE页面的网址，则为可运行当前程序的操作系统，否则不可运行。当前在世面上，找了好几家才找以这家可运行。

2、文件配置注意事项

	1）格式严格按照key=value的方式，中间不可出现空格
	
	2）debugRun:当前运行模式，为1会打印更多运行日志
	
	3）vcodeImgPath：验证码存储路径，系统会自动创建，请保证用户有创建权限;

	4）pythonMouseMoveExePath:移动鼠标的python程序，此程序只在非远程连接模式下运行有效，如正常模式，teamviewer模式。

	     此文件在解压后的dist目录
	
	5）exePath:验证码识别程序地址，解决当前vcode目录中的exe即为程序执行exe
	
	6）pwinLeft, pwinTop,只在程序无法正常获取到当前IE的pwinLeft, pwinTop时使用。可使用压缩包中的IESupportScreenPos.exe来获取。

		a)pwinLeft:一般都为0

		b)pwinTop:不同浏览器有不同的值，一般为89，可自行微调，控制验证码的定位
	
	7）supportAdsl：默认为0，即不支持重启adsl宽带连接;1为支持adsl连接

	8）loopSleep：每次循环中间的休息时间

	9）adTimeMis:iqiyi视频前的广告时间，毫秒

	10）isTest：是否是测试环境，1：为测试环境，即获取要播放的视频及账号使用的是开发者自行用来测试的数据，在生产环境下使用值0

3、在运行时，需确认vcode.rar中的dll.exe是否可正常执行。验证过程如下，在解决文件完成（vcode.rar）后，在cmd中，进入vcode的解压目录，执行dll.exe imgPath resultPath,如果程序能正常结束，即可在resultPath中看到imgPath中的验证码。

4、系统配置注意事项：

	1）IE配置：不要阻止弹出框

	2）在当前窗口的选项页内打开新链接

	3）安装flash，并选择不再进行更新

	4）不显示命名栏，收藏栏及菜单栏

	5）在关闭IE tabls选择关闭所有，并且下次不再提示

	6）取消在IE启动时对默认浏览器选项的检查

5、宽带连接设置

	1）宽带连接文件见目录下的start_rasdial.bat文件，在正式运行中，如果可以重启adsl，则请修改此文件，07149905141为adsl账号，请用自己的账号代替 123789为adsl密码，请用自己密码代替。

6、程序运行注意事项：

	1）由于远程连接的安全限制，程序无法在远程桌面中正常运行，只可以在不关闭远程桌面连接session的情况下正常运行

	2）程序可在teamviewer中启动，但如果程序在运行过程中，有用户从远程桌面进入当前机器，程序将会被中断正常运行。

	3）程序可在正常用户登录桌面运行。


程序内部具体流程如下：

一、获取数据

  1）自处理http请求，解析得到相关数据结构

  2）调用第三方程序，通过文件进行通信，获取相关数据结构

二、启动相关应用

三、获取操作相关应用的句柄，进行自动化操作

四、对于登录ocr处理

  1）调用第三方程序，根据对应文件进行通信，获取相关数据结构

五、更新环境后继续相关自动化操作

  1）搜索查找

  2）直接进入

六、根据步骤一获取到的数据，决定是否对五进行循环。

七、重置环境。继续循环一下到任务结束。