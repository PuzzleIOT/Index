using System;
using NUnit.Framework;

namespace NetSwitch.Index.Tests.Integration
{
	[TestFixture(Category = "Integration")]
	public class CreateNetSwitchNanoTestFixture : BaseTestFixture
	{
		[Test]
		public void Test_CreateNetSwitchNanoScript()
		{
			var scriptName = "create-switch-nano.sh";

			Console.WriteLine("Script:");
			Console.WriteLine(scriptName);

			var deviceType = "switch/NetSwitch";
			var deviceLabel = "MySwitch";
			var deviceName = "mySwitch";
			var devicePin = 13;
			var devicePort = "ttyUSB1";

			var arguments = deviceLabel + " " + deviceName + " " + devicePin + " " + devicePort;

			var starter = GetDockerProcessStarter();
			starter.PreCommand = "sh init-mock-setup.sh && sh clean.sh";
			starter.RunDockerBash("sh " + scriptName + " " + arguments);

			CheckDeviceInfoWasCreated(deviceType, deviceLabel, deviceName, devicePort);

			CheckDevicePinUIWasCreated(deviceLabel, deviceName, devicePin);

			CheckMqttBridgeServiceFileWasCreated(deviceName);

			//CheckUpdaterServiceFileWasCreated(deviceName);
		}
	}
}
