_initAccount()
{
	account := {}
	account.id := 1
	account.nickname := "爱吃甜品的南宫和宜"
	account.name := "13693243521"
	account.pwd := ""
	return account
}


_initAccount1()
{
	account := {}
	account.id := 2
	account.nickname := "SandyWangTing"
	account.name := "13810954201"
	account.pwd := ""
	return account
}

_initTasks()
{
	tasks := Object()
	task := {}
	task.id := 1
	task.searchKeyword := "G20"
	task.url := "http://www.iqiyi.com/lib/m_210812214.html"
	task.duration := 20
	tasks.Insert(task)	
	task := {}
	task.id := 2
	task.searchKeyword := "G20"
	task.url := "http://www.iqiyi.com/v_19rrm5n2to.html"
	task.duration := 20
	tasks.Insert(task)	
	task := {}
	task.id := 3
	task.searchKeyword := "G20"
	task.url := "http://www.iqiyi.com/w_19rstp7n61.html"
	task.duration := 20
	tasks.Insert(task)	
	task := {}
	task.id := 4
	task.searchKeyword := "G20"
	task.url := "http://www.iqiyi.com/w_19rsoreazx.html"
	task.duration := 20
	tasks.Insert(task)	
	task := {}
	task.id := 5
	task.searchKeyword := "G20"
	task.url := "http://www.iqiyi.com/v_19rrm497sg.html"
	task.duration := 20
	tasks.Insert(task)	
	;~ task := {}
	;~ task.id := 6
	;~ task.searchKeyword := "G20"
	;~ task.url := "http://www.iqiyi.com/w_19rst5ju0d.html#vfrm=2-3-0-1"
	;~ task.duration := 20
	;~ tasks.Insert(task)
	return tasks
}