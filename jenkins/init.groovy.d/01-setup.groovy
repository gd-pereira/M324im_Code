// Runs on every Jenkins start: configures the "node" tool and the trafficlight job.
import jenkins.model.Jenkins
import hudson.tools.InstallSourceProperty
import jenkins.plugins.nodejs.tools.NodeJSInstallation
import jenkins.plugins.nodejs.tools.NodeJSInstaller
import org.jenkinsci.plugins.workflow.job.WorkflowJob
import org.jenkinsci.plugins.workflow.cps.CpsFlowDefinition

def j = Jenkins.get()

// NodeJS tool named "node" (used by `tools { nodejs "node" }`)
def desc = j.getDescriptorByType(NodeJSInstallation.DescriptorImpl)
desc.setInstallations(new NodeJSInstallation(
    "node", "", [new InstallSourceProperty([new NodeJSInstaller("20.18.0", "", 72L)])]))
desc.save()

// Pipeline job whose script is /repo/jenkins/Jenkinsfile
def jf = new File('/repo/jenkins/Jenkinsfile')
if (jf.exists()) {
  def job = j.getItem('trafficlight') ?: j.createProject(WorkflowJob, 'trafficlight')
  job.setDefinition(new CpsFlowDefinition(jf.text, true))
  job.save()
}

// Allow git to read the bind-mounted repo
"git config --global --add safe.directory *".execute().waitFor()
