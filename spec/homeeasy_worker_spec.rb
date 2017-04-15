require 'homeeasy_worker'

RSpec.describe HomeeasyWorker, '#perform' do

  context 'when desired state is ON' do
	  let(:homeeasy) { instance_double('HomeEasy') }
    let(:homeeasy_worker) { HomeeasyWorker.new homeeasy }

    it 'tells HomeEasy to turn on the device' do
      expect(homeeasy).to receive(:on).with(2342)
      homeeasy_worker.perform(2342, 'on')
    end
  end

  context 'when desired state is OFF' do
	  let(:homeeasy) { instance_double('HomeEasy') }
    let(:homeeasy_worker) { HomeeasyWorker.new homeeasy }

    it 'tells HomeEasy to turn on the device' do
      expect(homeeasy).to receive(:off).with(8877)
      homeeasy_worker.perform(8877, 'off')
    end
  end
end
