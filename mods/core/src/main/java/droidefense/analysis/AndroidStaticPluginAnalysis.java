package droidefense.analysis;

import droidefense.analysis.base.AbstractAndroidAnalysis;
import droidefense.handler.DirScannerHandler;
import droidefense.handler.FileIOHandler;
import droidefense.handler.base.DirScannerFilter;
import droidefense.log4j.Log;
import droidefense.log4j.LoggerType;
import droidefense.sdk.AbstractStaticPlugin;
import droidefense.sdk.model.io.AbstractHashedFile;
import droidefense.sdk.util.ExecutionTimer;
import droidefense.sdk.util.InternalConstant;

import java.io.File;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLClassLoader;
import java.util.ArrayList;

/**
 * Created by sergio on 17/2/16.
 */
public final class AndroidStaticPluginAnalysis extends AbstractAndroidAnalysis {

    public transient static final String PLUGIN_PACKAGE_NAME = "droidefense.plugins.sttc.";

    public AndroidStaticPluginAnalysis() {
        timeStamp = new ExecutionTimer();
    }

    @Override
    public boolean analyze() {
        executionSuccessful = false;
        Log.write(LoggerType.TRACE, "\n\n --- Running Android static plugin analysis ---\n\n");
        File plFolder = FileIOHandler.getStaticPluginsFolderFile();
        if (plFolder.exists()) {
            DirScannerHandler scanner = new DirScannerHandler(plFolder, false, new DirScannerFilter() {
                @Override
                public boolean addFile(File f) {
                    return f.getName().endsWith(InternalConstant.COMPILED_JAVA_EXTENSION);
                }
            });
            scanner.doTheJob();
            ArrayList<AbstractHashedFile> pluginsList = scanner.getFiles();
            for (AbstractHashedFile plugin : pluginsList) {
                //run each plugin in a different thread
                String pluginName = plugin.getName();
                if (pluginName.endsWith(InternalConstant.COMPILED_JAVA_EXTENSION)) {
                    Log.write(LoggerType.TRACE, "");
                    Log.write(LoggerType.TRACE, " ######## PLUGIN ########");
                    Log.write(LoggerType.TRACE, plugin.getAbsolutePath());
                    Log.write(LoggerType.TRACE, " ######## PLUGIN ########");
                    Log.write(LoggerType.TRACE, "");
                    Class aClass;
                    try {
                        String pluginFullName = PLUGIN_PACKAGE_NAME + pluginName.replace(".class", "");
                        Log.write(LoggerType.DEBUG, "Loading plugin: " + pluginFullName);
                        aClass = getClass(plugin, pluginFullName);
                        if(aClass!=null){
                            Log.write(LoggerType.TRACE, "Executing plugin: " + aClass.getName());
                            AbstractStaticPlugin staticPlugin = (AbstractStaticPlugin) aClass.newInstance();

                            staticPlugin.setApk(apkFile);
                            staticPlugin.setCurrentProject(currentProject);
                            staticPlugin.analyze();

                            //add result to currentProject
                            currentProject.addStaticPlugin(staticPlugin);
                        }
                        else{
                            Log.write(LoggerType.FATAL, "Could not load external plugin");
                        }
                    } catch (Exception e) {
                        Log.write(LoggerType.FATAL, "Fatal error while executing external plugin", e.getLocalizedMessage());
                        addError(e);
                    }
                } else {
                    //todo load jar content using reflection. for more sofisticated plugins
                    Log.write(LoggerType.TRACE, plugin.getAbsolutePath());
                }
            }
            executionSuccessful = true;
        }
        Log.write(LoggerType.TRACE, "\n--- RUNNING PLUGINS (DONE)---\n");
        //stop timer
        stop();
        this.timeStamp.stop();
        return executionSuccessful;
    }

    //TODO load external .class file successfully
    private Class getClass(AbstractHashedFile plugin, String fullClassName) {
        File file = plugin.getParentDir();

        if(file!=null){
            //convert the file to URL format
            URL url;
            try {
                url = file.toURI().toURL();
                URL[] urls = new URL[]{url};

                //load this folder into Class loader
                ClassLoader cl = new URLClassLoader(urls);
                return cl.loadClass(fullClassName+".class");

                //print the location from where this class was loaded
            /*
            ProtectionDomain pDomain = cls.getProtectionDomain();
            CodeSource cSource = pDomain.getCodeSource();
            URL urlfrom = cSource.getLocation();
            System.out.println(urlfrom.getFile());
            */
            } catch (MalformedURLException e) {
                e.printStackTrace();
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
            }
        }
        return null;
    }

    @Override
    public String getName() {
        return "Android static plugin analysis";
    }

}
