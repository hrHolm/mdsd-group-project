/*
 * generated by Xtext 2.20.0
 */
package dk.sdu.mmmi.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import dk.sdu.mmmi.springBoard.SpringBoard
import dk.sdu.mmmi.springBoard.Package


/**
 * Generates code from your model files on save.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class SpringBoardGenerator extends AbstractGenerator {

	
	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
//		fsa.generateFile('greetings.txt', 'People to greet: ' + 
//			resource.allContents
//				.filter(Greeting)
//				.map[name]
//				.join(', '))

		val model = resource.allContents.filter(SpringBoard).next
		val packName = createPackageName(model.pkg)
		
		generateSpringProjectStructure(fsa, packName)
	}
	
	/**
	 * TODO: Remove hardcoded names 
	 */
	def generateSpringProjectStructure(IFileSystemAccess2 fsa, String packName) {
		fsa.generateFile("/pom.xml", generatePom(packName))
		fsa.generateFile("src/main/java/"+packName.replace('.', '/')+"/DemoApplication.java", generateSource(packName))
		fsa.generateFile("src/test/java/"+packName.replace('.', '/')+"/DemoApplicationTests.java", generateTest(packName))
		fsa.generateFile("src/main/resources/application.properties", generateProperties())
	}
	
	def CharSequence generateProperties()''' '''
	
	def CharSequence generateTest(String packName)'''
	package �packName�;
	import org.junit.jupiter.api.Test;
	import org.springframework.boot.test.context.SpringBootTest;
	
	@SpringBootTest
	class DemoApplicationTests {
		
	  @Test
	  void contextLoads() {
	  }
	  
	}
	
	'''
	
	
	
	
	
	def createPackageName(Package pack) {
		var packIter = pack
		var name = packIter.name
		
		while (packIter.next !== null) {
			packIter = packIter.next
			name += ('.'+packIter.name)
		}
		return name
	}
	def CharSequence generatePom(String packName)'''
	<?xml version="1.0" encoding="UTF-8"?>
	<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
	  <modelVersion>4.0.0</modelVersion>
	  <parent>
	    <groupId>org.springframework.boot</groupId>
	    <artifactId>spring-boot-starter-parent</artifactId>
	    <version>2.2.6.RELEASE</version>
	    <relativePath/> <!-- lookup parent from repository -->
	  </parent>
	  <groupId>�packName�</groupId>
	  <artifactId>demo</artifactId>
	  <version>0.0.1-SNAPSHOT</version>
	  <name>demo</name>
	  <description>Demo project for Spring Boot</description>
	  <properties>
	    <java.version>11</java.version>
	  </properties>
	  <dependencies>
	    <dependency>
	      <groupId>org.springframework.boot</groupId>
	      <artifactId>spring-boot-starter-web</artifactId>
	    </dependency>
	    <dependency>
	      <groupId>org.springframework.boot</groupId>
	      <artifactId>spring-boot-starter-test</artifactId>
	      <scope>test</scope>
	      <exclusions>
	        <exclusion>
	          <groupId>org.junit.vintage</groupId>
	          <artifactId>junit-vintage-engine</artifactId>
	        </exclusion>
	      </exclusions>
	    </dependency>
	  </dependencies>
	  <build>
	    <plugins>
	      <plugin>
	        <groupId>org.springframework.boot</groupId>
	        <artifactId>spring-boot-maven-plugin</artifactId>
	      </plugin>
	    </plugins>
	  </build>
	</project>
	'''
	
	def CharSequence generateSource(String packName)'''
	package �packName�;
	
	import org.springframework.boot.SpringApplication;
	import org.springframework.boot.autoconfigure.SpringBootApplication;
	
	@SpringBootApplication
	public class DemoApplication {
	  public static void main(String[] args) {
	    SpringApplication.run(DemoApplication.class, args);
	  }
	}
	'''
}
