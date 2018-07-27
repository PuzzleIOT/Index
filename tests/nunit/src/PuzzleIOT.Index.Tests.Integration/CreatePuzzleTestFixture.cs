
using System;
using NUnit.Framework;
using System.IO;

namespace NetSwitch.Index.Tests.Integration
{
	[TestFixture(Category = "Integration")]
	public class CreatePuzzleTestFixture : BaseTestFixture
	{
		[Test]
		public void Test_CreatePuzzleScript()
		{
			var scriptName = "create-puzzle";

			Console.WriteLine("Script:");
			Console.WriteLine(scriptName);

			Console.WriteLine("Running script");

			var starter = GetDockerProcessStarter();
			starter.PreCommand = "sh init-mock-setup.sh";
			var output = starter.RunScript(scriptName);

			var successfulText = "Setup complete";

			Assert.IsTrue(output.Contains(successfulText), "Failed");

			var serviceFileName = "puzzleiot-mosquitto-docker.service";

			CheckServiceExists(serviceFileName);
		}

		public void CheckServiceExists(string serviceFileName)
		{
			if (!serviceFileName.EndsWith(".service"))
				serviceFileName += ".service";

			var serviceFilePath = Path.Combine(TemporaryServicesDirectory, serviceFileName);

			Console.WriteLine("Checking mosquitto service file exists...");
			Console.WriteLine("  " + serviceFilePath);

			var serviceFileExists = File.Exists(serviceFilePath);

			Assert.IsTrue(serviceFileExists, "Service file not found.");
		}
	}
}
