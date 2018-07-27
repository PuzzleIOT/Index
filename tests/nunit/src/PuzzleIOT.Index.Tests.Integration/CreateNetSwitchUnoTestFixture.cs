using System;
using NUnit.Framework;

namespace NetSwitch.Index.Tests.Integration
{
	[TestFixture(Category = "Integration")]
	public class CreateNetSwitchUnoTestFixture : BaseTestFixture
	{
		[Test]
		public void Test_CreateNetSwitchUnoScript()
		{
			var scriptName = "create-switch-uno.sh";

			Console.WriteLine("Script:");
			Console.WriteLine(scriptName);

			var deviceType = "switch/NetSwitch";
			var deviceLabel = "MySwitch";
			var deviceName = "mySwitch";
			var devicePort = "ttyUSB1";

			var arguments = deviceLabel + " " + deviceName + " " + devicePort;

			var starter = GetDockerProcessStarter();
			starter.PreCommand = "sh init-mock-setup.sh";
			starter.RunDockerBash("sh " + scriptName + " " + arguments);

			CheckDeviceInfoWasCreated(deviceType, deviceLabel, deviceName, devicePort);

			CheckDeviceUIWasCreated(deviceLabel, deviceName);

			CheckMqttBridgeServiceFileWasCreated(deviceName);

			CheckUpdaterServiceFileWasCreated(deviceName);
		}
	}
}
