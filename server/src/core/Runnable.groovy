package core

import groovy.time.*

class Runnable
{
	public static Object run(path, timeout = 1000, input = "")
	{
		def result = [:]

		try
		{
			ProcessBuilder builder = new ProcessBuilder(path)

			builder.redirectErrorStream(true)

			Process process = builder.start()

			Scanner reader = new Scanner(process.getInputStream())
			Scanner error_reader = new Scanner(process.getErrorStream())
			PrintWriter writer = new PrintWriter(process.getOutputStream())

			use (TimeCategory)
			{
				if (input != null)
					writer.write(input + "\n")
				
				Date startTime = new Date()
					
				writer.flush()

				process.waitForOrKill(timeout)

				Date endTime = new Date()
				
				Integer deltaTime = (endTime - startTime).toMilliseconds()

				String output = ""

				while (reader.hasNext())
				{
					output += reader.nextLine()
				}

				String errors = ""

				if (error_reader.hasNext())
				{
					while (error_reader.hasNext())
					{
						errors += error_reader.nextLine()
					}
				}
				
				if (errors.trim().length() <= 0)
					errors = null

				result['binary'] = path
				result["output"] = output
				result["run_time"] = deltaTime
				result["errors"] = errors
				result["exit_value"] = process.exitValue()
			}
		} catch (Exception e)
		{
			e.printStackTrace()
		}

		return result
	}
}