package com.test.coroutine;


import org.luaj.vm2.Globals;
import org.luaj.vm2.lib.jse.JsePlatform;

import java.io.IOException;

public class CoroutineStart {

    static class Runner implements Runnable {
        final String script1;
        Runner(String script1) {
            this.script1 = script1;
        }
        public void run() {
            try {
                // Each thread must have its own Globals.
                Globals g = JsePlatform.standardGlobals();

                // Once a Globals is created, it can and should be reused
                // within the same thread.
                g.loadfile(script1).call();

            } catch ( Exception e ) {
                e.printStackTrace();
            }
        }
    }

    public static void main(final String[] args) throws IOException {
        final String script1 = args.length > 0? args[0]: "test/lua/errors/coroutinelibargs.lua";
        try {
            Thread[] thread = new Thread[1];
            for (int i = 0; i < thread.length; ++i)
                thread[i] = new Thread(new CoroutineStart.Runner(script1),"Runner-"+i);
            for (int i = 0; i < thread.length; ++i)
                thread[i].start();
            for (int i = 0; i < thread.length; ++i)
                thread[i].join();
            System.out.println("done");
        } catch ( Exception e ) {
            e.printStackTrace();
        }
    }
}
