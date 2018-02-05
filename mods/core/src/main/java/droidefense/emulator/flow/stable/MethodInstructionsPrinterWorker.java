package droidefense.emulator.flow.stable;

import droidefense.emulator.machine.base.AbstractDVMThread;
import droidefense.emulator.machine.base.struct.generic.IDroidefenseFrame;
import droidefense.emulator.machine.base.struct.generic.IDroidefenseMethod;
import droidefense.emulator.machine.inst.DalvikInstruction;
import droidefense.log4j.Log;
import droidefense.log4j.LoggerType;
import droidefense.sdk.model.base.DroidefenseProject;

public class MethodInstructionsPrinterWorker extends SimpleFlowWorker {

    public MethodInstructionsPrinterWorker(DroidefenseProject project) {
        super(project);
        this.name = "MethodInstructionsPrinterWorker";
        fromNode = null;
    }

    @Override
    public void finish() {
        Log.write(LoggerType.DEBUG, "WORKER: MethodInstructionsPrinterWorker FINISHED!");
    }

    public void onNewInstruction(IDroidefenseFrame frame, DalvikInstruction instruction){
        Log.write(LoggerType.TRACE, instruction.name() + " " + instruction.description());
        frame.increasePc(instruction.fakePcIncrement());
    }

    @Override
    public strictfp void execute(boolean keepScanning) throws Throwable {

        IDroidefenseFrame frame = getCurrentFrame();

        if (frame != null) {
            IDroidefenseMethod method = frame.getMethod();

            opCodes = method.getOpcodes();
            registerCodes = method.getRegisterOpcodes();
            codes = method.getIndex();
            int currentPc;
            do{

                currentPc = frame.getPc();
                int currentInstructionOpcode;

                currentInstructionOpcode = opCodes[currentPc];
                DalvikInstruction currentInstruction = AbstractDVMThread.instructions[currentInstructionOpcode];

                //this has to be abstract part of the worker
                onNewInstruction(frame, currentInstruction);
            } while (keepScanning(currentPc));
        }
    }
}