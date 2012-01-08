package core

import groovy.sql.Sql
import groovy.xml.MarkupBuilder
import groovy.time.*

import java.lang.ProcessBuilder
import java.lang.Process
import java.sql.ResultSet;
import java.util.Scanner

import java.util.zip.*

import core.Runnable

class Main
{

	private compilerList
	private classLoader
	private serverPort

	private dbConnectionString
	private dbDriverString
	private dbUser
	private dbPassword

	public def Main()
	{
		this.compilerList = [:]
		this.classLoader = null
		
		/* These must be loaded from XML config file */
		def config = new XmlParser().parse(new File("config.xml"))
		
		this.serverPort = config.server.port.text() ?: 3780
		this.dbConnectionString = config.db.host.text() ?: "jdbc:mysql://localhost/moocoder"
		this.dbDriverString = config.db.driver.text() ?: "com.mysql.jdbc.Driver"
		this.dbUser = config.db.user.text() ?: "root"
		this.dbPassword = config.db.password.text() ?: ""
				
		/*this.serverPort = 3780

		this.dbConnectionString = "jdbc:mysql://localhost/moocoder"
		this.dbDriverString = "com.mysql.jdbc.Driver"
		this.dbUser = "root"
		this.dbPassword = ""*/
		/* End these */

		// Loading compiler list
		def compilerURLList = []

		new File("plugins").eachFile
		{ file ->
			if (file.isFile() && file ==~ '^.+Compiler\\.jar$')
			{
				compilerURLList.add(file.toURI().toURL())

				String className = file.path.replaceAll('^plugins.*(\\\\|\\/)(\\w+)\\.jar$', '$2')
				String pluginName = className.replaceAll('^(\\w+)Compiler$', '$1').toLowerCase()

				compilerList[pluginName] = className
			}
		}

		// Creating ClassLoader instance to use externally plugged compilers
		classLoader = new URLClassLoader((URL[]) compilerURLList)
	}

	public checkSolution(solutionId)
	{
		// Connect to the DB
		def connection = Sql.newInstance(this.dbConnectionString, this.dbUser, this.dbPassword, 
			this.dbDriverString)
		
		// Get the solution parameters from the DB
		connection.eachRow("select * from solutions where id = ?", [ solutionId ]) {
			solution ->
			
			connection.execute("delete from results where solution_id = ${ solutionId }")
			
			if (this.compilerList[solution.compiler])
			{
				Class c = this.classLoader.loadClass(this.compilerList[solution.compiler])
				
				String binary = null

				binary = c.invokeMethod("main", (String[]) [ solution.code, solution.id])
				
				if (binary == null)
				{
					connection.eachRow("select * from tests where task_id = ?", [ solution.task_id ]) {
						test ->
						
						connection.execute("insert into results (test_id, task_id, solution_id, status) values (?, ?, ?, ?)",
							[test.id, test.task_id, solutionId, 1])
					}
					
					throw new Exception("File compilation failed")
				}
					
				if (!(new File(binary).exists()))
				{
					connection.eachRow("select * from tests where task_id = ?", [ solution.task_id ]) {
						test ->
						
						connection.execute("insert into results (test_id, task_id, solution_id, status) values (?, ?, ?, ?)",
							[test.id, test.task_id, solutionId, 1])
					}
					
					throw new Exception("Binary ${ binary } not found!")
				}
				
				connection.eachRow("select * from tests where task_id = ?", [ solution.task_id ]) {
					test ->
					
					def result = Runnable.run(binary, test.timeout, test.input)
					
					/*
					 * Status manual:
					 * 
					 * 000000 - default; nothing happened
					 * 000001 - runtime errors
					 * 000010 - runtime error (wrong exit code)
					 * 000100 - timeout limit exceeded
					 * 001000 - no output
					 * 100000 - incorrect answer
					 * 110000 - passed
					 */
					
					int status = 0
					
					if (result['errors'] != null)
						status |= 1
						
					if (result['exit_value'] != 0)
						status |= 2
						
					if (result['run_time'] > test.timeout)
						status |= 4
						
					if (result['output'] == null)
						status |= 8
						
					if (result['output'].trim() == test.output.trim())
						status |= (32 | 16); else
							status |= 32
						
					println "Result: ${ result }\nOutput is: ${ result['output'].trim() == test.output.trim() }\nStatus: ${ status }\n\n"
					
					connection.execute("insert into results (test_id, task_id, solution_id, status) values (?, ?, ?, ?)",
						[test.id, test.task_id, solution.id, status])
				}
				
				println "Deleting ${ binary } file: ${ new File(binary).delete() }"
			} else
			{
				connection.execute("insert into results (test_id, task_id, solution_id, status) values (?, ?, ?, ?)",
					[0, solution.task_id, solution.id, -1])
			}
		}
	}
	
	public handleConnection(client)
	{
		PrintWriter socketwriter = new PrintWriter(client.getOutputStream())
		socketwriter.print("Connection: Done.\n")
		socketwriter.flush()

		Scanner socketreader = new Scanner(client.getInputStream())

		def solutionId = -1

		if (socketreader.hasNextInt())
		{
			solutionId = socketreader.nextInt()
			this.checkSolution(solutionId)
			
			socketwriter.print("Reading: Done with ${ solutionId }.\n")
		} else
		{
			socketwriter.print("Reading: Failed.\n")
		}

		socketwriter.flush()
		socketreader.close()
	}

	public startServer()
	{
		ServerSocket serversocket = new ServerSocket(Integer.parseInt(this.serverPort))
		
		println "Server is up and running on ${ this.serverPort } port."

		try
		{
			while (true)
			{
				Socket client = serversocket.accept()
	
				Thread.start {
					this.handleConnection(client)
				}
			}
		} finally
		{
			serversocket.close()
		}
	}

	static main(args)
	{
		try
		{
			def runnable = new Main()
			
			runnable.startServer()
		} catch (e)
		{
			e.printStackTrace()
		}
	}
}
