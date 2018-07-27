using System;
using NUnit.Framework;

namespace NetSwitch.Index.Tests.Integration
{
	[TestFixture(Category = "Integration")]
	public class CreateNetSwitchEspTestFixture : BaseTestFixture
	{
		[Test]
		public void Test_CreateNetSwitchEspScript()
		{
			var scriptName = "test-switch-esp";

			Console.WriteLine("Script:");
			Console.WriteLine(scriptName);

			var starter = GetDockerProcessStarter();
			starter.PreCommand = "sh init-mock-setup.sh";
			var output = starter.RunScript(scriptName);

			var successfulText = "Switch ESP8266 test complete";

			Assert.IsTrue(output.Contains(successfulText), "Failed");

			var type = "switch/SoilMoistureSensorCalibratedPumpESP";
			var label = "MySwitch";
			var name = "myirrigator";
			var port = "ttyUSB1";

			CheckDeviceInfoWasCreated(type, label, name, port);

			CheckDeviceUIWasCreated(label, name);
		}
	}
}
