package dk.sdu.mmmi.generator

import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import dk.sdu.mmmi.springBoard.Service
import dk.sdu.mmmi.springBoard.CRUDActions
import dk.sdu.mmmi.springBoard.Dt
import dk.sdu.mmmi.springBoard.ListOf
import dk.sdu.mmmi.springBoard.Str
import dk.sdu.mmmi.springBoard.Int
import dk.sdu.mmmi.springBoard.Lon
import dk.sdu.mmmi.springBoard.Bool
import dk.sdu.mmmi.springBoard.Identifier
import dk.sdu.mmmi.springBoard.ModelType

class ServiceGenerator {
	
	val mavenSrcStructure = "src/main/java/"
	
	def CharSequence generateService(String packageName, Service service) '''
		package �packageName�;
		
		import java.util.List;
		
		public interface I�service.base.name� {
			
			�IF service.crud != null�
				�generateCrud(service)�
			�ENDIF�
			�FOR m:service.methods�
				public �m.type.show� �m.name�(�FOR a:m.inp.args� �a.type.show� �a.name� �ENDFOR�);
				 
			�ENDFOR�
		}
	'''
	
	def CharSequence generateCrud(Service ser)'''
		�FOR a:ser.crud.act�
			�IF a == CRUDActions.C�
				public boolean create(�ser.base.name� _�ser.base.name�);
				
			�ENDIF�
			�IF a == CRUDActions.R�
				public List<�ser.base.name�> findAll();
				
				public �ser.base.name� find(Long id);
				
			�ENDIF�
			�IF a == CRUDActions.U�
				public boolean update(Long id);
				
				public boolean update(�ser.base.name� _�ser.base.name�);
				
			�ENDIF�
			�IF a == CRUDActions.D�
				public boolean delete(Long id);
				
				public boolean delete(�ser.base.name� _�ser.base.name�);
				
			�ENDIF�
		�ENDFOR�
	'''
	
	def dispatch CharSequence show(Dt dt)'''DateTime'''
	
	def dispatch CharSequence show(ListOf lo)'''List<�lo.type.show�>'''
	
	def dispatch CharSequence show(Str st)'''String'''
	
	def dispatch CharSequence show(Int in)'''Integer'''
	
	def dispatch CharSequence show(Lon l)'''Long'''
	
	def dispatch CharSequence show(Bool b)'''boolean'''
	
	def dispatch CharSequence show(Identifier id)'''Long'''
	
	def dispatch CharSequence show(ModelType m) '''�m.base.name�'''
	
	def createService(IFileSystemAccess2 fsa, String packageName, Service service) {
		fsa.generateFile(mavenSrcStructure+packageName.replace('.', '/')+"/services/I"+service.base.name+'.java', generateService(packageName, service))
	}
}