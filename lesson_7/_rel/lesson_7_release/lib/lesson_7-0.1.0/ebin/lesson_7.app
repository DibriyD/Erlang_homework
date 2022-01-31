{application, 'lesson_7', [
	{description, "New project"},
	{vsn, "0.1.0"},
	{modules, ['cache_handler','cache_server','convert_date','lesson_7_app','lesson_7_sup']},
	{registered, [lesson_7_sup]},
	{applications, [kernel,stdlib,cowboy,jiffy]},
	{mod, {lesson_7_app, []}},
	{env, []}
]}.