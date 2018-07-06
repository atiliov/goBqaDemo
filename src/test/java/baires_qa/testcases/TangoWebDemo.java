package baires_qa.testcases;


import baires_qa.utils.BaseTestCases;
import baires_qa.utils.SuiteTrack;
import org.testng.annotations.AfterSuite;
import org.testng.annotations.Test;


/**
 * Created by bairesqa on 10/1/2015.
 * El Nombre del programa lo toma del nombre de la clase
 *
 */
public class TangoWebDemo extends BaseTestCases {


    @AfterSuite
    public void report() {
        new SuiteTrack(this.getClass().getSimpleName()).printReport();
    }

    @Test(dataProvider="BaseTestCases")
    public void testDemo( String testcaseName,String testActive, String browser,String keyword,
                              String objectName,String objectType,String value, String comment)
            throws Exception {

       this.testLine( testcaseName,testActive,browser,keyword,objectName,objectType,value, comment);
    }

}
