using System;
using NUnit.Framework;
using System.IO;
using Newtonsoft.Json.Linq;
namespace NetSwitch.Index.Tests.Unit
{
	[TestFixture(Category = "Unit")]
	public class CreateNetSwitchUITestFixture : BaseTestFixture
	{
		[Test]
		public void Test_CreateNetSwitchUI()
		{
			var scriptName = "create-netswitch-ui.sh";

			Console.WriteLine("Testing " + scriptName + " script");

			var deviceLabel = "Switch1";
			var deviceName = "switch1";

			var arguments = deviceLabel + " " + deviceName;

			var command = "sh " + scriptName + " " + arguments;

			var starter = new ProcessStarter();

			Console.WriteLine("Running script...");

			starter.Start(command);

			var output = starter.Output;

			Console.WriteLine("Checking device UI was created...");

			CheckDeviceUIWasCreated(deviceLabel, deviceName);

			Console.WriteLine("Creating device info folder...");

			Directory.CreateDirectory(Path.GetFullPath("devices/" + deviceName));

			Console.WriteLine("Attempting to create a duplicate...");

			starter.Start(command);

			Console.WriteLine("Ensuring that no duplicate UI was created...");

			CheckDeviceUICount(1);
		}
	}
}
